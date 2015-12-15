package OpenSoC

import Chisel._
import scala.collection.mutable.LinkedHashMap

/*
class My_System


class My_SystemTest {

}
*/

class PortDataSink(parms: Parameters) extends Module(parms) {
  val io = new Bundle {
    val in = new Channel(parms)
    val count = UInt(OUTPUT, width = 32)
    val dump = Bits(OUTPUT, width = in.flit.getWidth())
  }

  val count = Reg(init = UInt(0, width = 32))
  val dump = Reg(outType = Bits(width = io.in.flit.getWidth()))

  io.count := count
  io.in.credit.grant := Bool(true)
  io.dump := dump

  when (io.in.flitValid) {
    count := count + UInt(1)
    dump := dump ^ io.in.flit.toBits
  }

}

class PortDataGenTester(c: PortDataGen, parms: Parameters) extends Tester(c) {
    reset(1)

    poke(c.io.out.packetReady, 0)
    step(5)

    poke(c.io.out.packetReady, 1)
    step(2)

    poke(c.io.out.packetReady, 0)
    step(2)

    poke(c.io.out.packetReady, 1)
    step(100)

    poke(c.io.out.packetReady, 0)
    step(2)
}

class PortDataConfig extends Bundle {
    val sequence = Bool()
	val destination = Vec.fill(3) { UInt(width = 2) }
    val count = UInt(width = 32)
}

class PortDataGen(parms: Parameters) extends Module(parms) {
    val io = new Bundle {
      val config = Decoupled(new PortDataConfig()).flip
      val out = new ReadyValid[Flit](parms, (p) => new Flit(p)).flip()
    }

	val headExtract = Chisel.Module( new HeadBundle2Flit(parms) )
	val bodyExtract = Chisel.Module( new BodyBundle2Flit(parms) )

    val s_start :: s_idle :: s_sendHead :: s_sendTail :: Nil = Enum(UInt(),4)
    val state = Reg(init = s_start)
    val config = Reg(outType = new PortDataConfig())

    val initCount = Reg(init = UInt(64))
    val count = Reg(init = UInt(10, width = 32))

    val lfsr = LFSR16()
    val lfsr_prev = Reg(init = UInt(0xF25A, width = 16))

    val flip = Reg(outType = UInt(width = 1))

    headExtract.io.inHead.isTail := Bool(false)
    headExtract.io.inHead.packetID := UInt(0) 
    headExtract.io.inHead.packetType := UInt(0)
    headExtract.io.inHead.destination(0) := config.destination(0) 
    headExtract.io.inHead.destination(1) := config.destination(1)
    headExtract.io.inHead.destination(2) := config.destination(2) 
    headExtract.io.inHead.vcPort := flip // UInt(0)
    headExtract.io.inHead.priorityLevel := UInt(0)

    bodyExtract.io.inBody.isTail := Bool(true)
    bodyExtract.io.inBody.packetID := UInt(0) 
    bodyExtract.io.inBody.vcPort := flip // UInt(0)
    bodyExtract.io.inBody.flitID := UInt(0)

    lfsr_prev := lfsr

    when (config.sequence) {
      bodyExtract.io.inBody.payload := count 
    }.otherwise {
      bodyExtract.io.inBody.payload := Cat(lfsr  ^ lfsr_prev, lfsr) 
    }

    when (state === s_start) {
        io.out.packetValid := Bool(false)
        io.out.packet := new Flit(parms).fromBits(UInt(0)) 
        
        io.config.ready := Bool(false)
        when (initCount != UInt(0)) {
          initCount := initCount - UInt(1)
        }.otherwise {
          state := s_idle
        }

    }.elsewhen (state === s_idle) {
        io.out.packetValid := Bool(false)
        io.out.packet := new Flit(parms).fromBits(UInt(0)) 

        when (config.count === UInt(0)) {
          io.config.ready := Bool(true)
          when (io.config.valid) {
            config := io.config.bits
          }

        }.otherwise {
          state := s_sendHead
        }

    }.elsewhen(state === s_sendHead) {
        io.config.ready := Bool(false)
        when (io.out.packetReady) {
          state := s_sendTail

          io.out.packetValid := Bool(true)
          io.out.packet := headExtract.io.outFlit
        }

    }.elsewhen(state === s_sendTail) {
        io.config.ready := Bool(false)
        when (io.out.packetReady) {
          when (config.count - UInt(1) === UInt(0)) {
            state := s_idle
          }.otherwise {
            state := s_sendHead
          }

          count := count + UInt(1)
          config.count := config.count - UInt(1)
          flip := ~flip

          io.out.packetValid := Bool(true)
          io.out.packet := bodyExtract.io.outFlit
        }

    }.otherwise {
        io.config.ready := Bool(false)
        io.out.packetValid := Bool(false)
        io.out.packet := new Flit(parms).fromBits(UInt(0))
    }




}

class My_MeshWrapperTest(c: My_MeshWrapper, parms: Parameters) extends Tester(c) {
    val flitpairs = 6
    var ready : BigInt = 0
 
    reset(1)
    step(2)

	val destmap = scala.collection.immutable.Map(0 -> 2, 1 -> 1, 2 -> 0)
	val enmap = scala.collection.immutable.Map(0 -> true, 1 -> false, 2 -> true)
	var encount = 0

	for (i <- 0 until c.io.config.length) {
		poke(c.io.config(i).bits.destination(0), destmap(i))
		poke(c.io.config(i).bits.destination(1), 0)
		poke(c.io.config(i).bits.destination(2), 0)
		poke(c.io.config(i).bits.count, flitpairs)
		poke(c.io.config(i).valid, 0)

		if (enmap(i)) {
			poke(c.io.config(i).valid, 1)
			ready = peek(c.io.config(i).ready)
			while (ready == 0) {
			  step(1)
			  ready = peek(c.io.config(i).ready)
			}
			step(1)
			poke(c.io.config(i).valid, 0)
			encount += 1
		}
	}

    var count : BigInt = 0
    do {
      count = 0
      for (i <- 0 until c.io.count.length) {
        count += peek(c.io.count(i))
      }
      step(1);
    } while (count != 2 * flitpairs * encount) 

    step(100)
}

class My_MeshWrapper(parms: Parameters) extends Module(parms) {
	val Dim = parms.get[Int]("TopologyDimension") // Dimension of topology
	val K = parms.get[Vector[Int]]("RoutersPerDim") // Routers per dimension.
	val C = parms.get[Int]("Concentration") // Processors (endpoints) per router.
	val numRouters : Int = K.product
	val numPorts = numRouters * C
  
    val io = new Bundle {
      val config = Vec.fill(numPorts) { Decoupled(new PortDataConfig()).flip }
      val count = Vec.fill(numPorts) { UInt(OUTPUT, width = 32) }
      val dump = Vec.fill(numPorts) { Bits(OUTPUT, width = (new Flit(parms)).getWidth()) }
      val bypass = Vec.fill(numRouters) { Bool(INPUT) }
    }

    val mesh = Chisel.Module(new My_Mesh[Flit](parms, (p) => new Flit(p)))

    for (i <- 0 until numRouters) {
      mesh.io.bypass(i) := io.bypass(i)
    }

    // Connect data generator and sink to mesh
 	for (i <- 0 until mesh.numPorts) {
	    val portdatagen = Chisel.Module(new PortDataGen(parms))
		mesh.io.ports(i).in <> portdatagen.io.out
	    io.config(i) <> portdatagen.io.config
	}

    for (i <- 0 until mesh.numPorts) {
        val portdatasink = Chisel.Module(new PortDataSink(parms))

        mesh.io.ports(i).out <> portdatasink.io.in
        io.count(i) <> portdatasink.io.count
        io.dump(i) <> portdatasink.io.dump
    }
}

class VCRouterBypass(parms: Parameters) extends BlackBox {
	val numInChannels 	= parms.get[Int]("numInChannels")
	val numOutChannels 	= parms.get[Int]("numOutChannels")
	val numVCs = parms.get[Int]("numVCs")

    addClock(Driver.implicitClock)
    addResetPin(Driver.implicitReset) 

    val io = new Bundle {
        val x = new Bundle {
            val inChannels = Vec.fill(numInChannels) { new ChannelVC(parms) }
            val outChannels = Vec.fill(numOutChannels) { new ChannelVC(parms).flip() }
            val counters = Vec.fill(2) {new CounterIO }
        }
        val y = new Bundle {
            val inChannels = Vec.fill(numInChannels) { new ChannelVC(parms).flip() }
            val outChannels = Vec.fill(numOutChannels) { new ChannelVC(parms) }
            val counters = Vec.fill(2) {(new CounterIO).flip() }
        }
        val bypass = Bool(INPUT)
        val clkOut = Bool(OUTPUT)
    }
}

class VCRouterWrapper(parms: Parameters) extends VCRouter(parms) {
    val bp = Chisel.Module(new VCRouterBypass(parms))
    val x = Chisel.Module(new SimpleVCRouter(parms))

    io <> bp.io.x
    bp.io.y <> x.io
    bp.io.bypass := io.bypass

}

class My_MeshTest(c: My_Mesh[Flit], parms: Parameters) extends Tester(c) {
	reset(1)

    step(100)
}

class My_Mesh[T<: Data](parms: Parameters, tGen : Parameters => T) extends Module(parms) {
	val Dim = parms.get[Int]("TopologyDimension") // Dimension of topology
	val K = parms.get[Vector[Int]]("RoutersPerDim") // Routers per dimension.
	val C = parms.get[Int]("Concentration") // Processors (endpoints) per router.
	val numRouters : Int = K.product //Math.pow(K, Dim).toInt
	val numPorts = numRouters * C// K.product//(Math.pow(K,Dim)*C).toInt // K^Dim = numRouters, numRouters*C = numPorts
	val queueDepth = parms.get[Int]("queueDepth")
	val numVCs = parms.get[Int]("numVCs")
	val routerRadix = 2 * Dim + C
	val counterMax = UInt(32768)


	val io = new Bundle {
		val ports 	= Vec.fill(numPorts) { new OpenSoCChannelPort[T](parms,tGen)}
/*		val headFlitsIn  = Vec.fill(numPorts) { new HeadFlit(parms).asInput }
		val headFlitsOut = Vec.fill(numPorts) { new Flit(parms).asOutput }
		val bodyFlitsIn  = Vec.fill(numPorts) { new BodyFlit(parms).asInput }
		val bodyFlitsOut = Vec.fill(numPorts) { new Flit(parms).asOutput }
		val flitsIn		 = Vec.fill(numPorts) { new Flit(parms).asInput }
		val flitsOutAsHead = Vec.fill(numPorts) { new HeadFlit(parms).asOutput }
		val flitsOutAsBody = Vec.fill(numPorts) { new BodyFlit(parms).asOutput }
        val portsAsHeadFlits = Vec.fill(numPorts)   { new HeadFlit(parms).asOutput }
        val portsAsBodyFlits = Vec.fill(numPorts)   { new BodyFlit(parms).asOutput }*/
        val bypass = Vec.fill(numRouters){ Bool(INPUT) }

		val cyclesRouterBusy	= Vec.fill(numRouters){ UInt(OUTPUT, width=counterMax.getWidth)}
		val cyclesChannelBusy	= Vec.fill(numRouters*routerRadix){UInt(OUTPUT, width=counterMax.getWidth)}
	}


	for (port <- 0 until numPorts){
/*		var headExtracter           = Chisel.Module( new HeadBundle2Flit(parms) )
		var bodyExtracter           = Chisel.Module( new BodyBundle2Flit(parms) )
		var flit2flit	            = Chisel.Module( new Flit2FlitBundle(parms) )
        var flitTranslate           = Chisel.Module( new Flit2FlitBundle(parms) )
		io.headFlitsIn(port) 	    <> 	headExtracter.io.inHead
		io.headFlitsOut(port)	    <>	headExtracter.io.outFlit
		io.bodyFlitsIn(port)	    <> 	bodyExtracter.io.inBody
		io.bodyFlitsOut(port)	    <>	bodyExtracter.io.outFlit
		io.flitsIn(port)		    <>  flit2flit.io.inFlit
		io.flitsOutAsHead(port)	    <>  flit2flit.io.outHead
		io.flitsOutAsBody(port) 	<>  flit2flit.io.outBody
        flitTranslate.io.inFlit :=      io.ports(port).out.flit       
        io.portsAsHeadFlits(port)   <>  flitTranslate.io.outHead
        io.portsAsBodyFlits(port)   <>  flitTranslate.io.outBody*/
	}

	println("numVCs: " + numVCs)
	
	if (numVCs < 2) {
		println("In Wormhole Mode")
		println("------------------")
		val topology = Chisel.Module(
			new CMesh(parms.child("CMeshTopo", Map(
				("topoInCredits"->Soft(queueDepth)),
				("topoOutCredits"->Soft(queueDepth)),

				("rfCtor"->Soft((parms: Parameters) => new CMeshDOR(parms))),
				("routerCtor"->Soft((parms: Parameters) => new SimpleRouter(parms)))
		))))

		for (i <- 0 until numPorts) {
			val injectionQ = Chisel.Module( new GenericChannelQ(parms.child(("InjectionQ", i)))  )
			val ejectionQ = Chisel.Module( new GenericChannelQ(parms.child(("EjectionQ", i))) )
			val inputNetIface = Chisel.Module( new InputPacketInterface[T](parms.child(("inputNetIface", i)),tGen) )

			inputNetIface.io.in.bits := io.ports(i).in.packet 
			inputNetIface.io.in.valid := io.ports(i).in.packetValid
			io.ports(i).in.packetReady := inputNetIface.io.in.ready
		
			injectionQ.io.in <> inputNetIface.io.out

			topology.io.inChannels(i) <> injectionQ.io.out
			ejectionQ.io.in <> topology.io.outChannels(i)
			io.ports(i).out <> ejectionQ.io.out
		}
	    for (r <- 0 until numRouters) {
		    io.cyclesRouterBusy(r) := topology.io.cyclesRouterBusy(r)
    		for(c <- 0 until routerRadix) {
	    		io.cyclesChannelBusy((r*routerRadix) + c) := topology.io.cyclesChannelBusy((r*routerRadix) + c)
	    	}
        }
	} else {	
		println("In VC Mode")
		println("------------------")
		val topology = Chisel.Module(
			new VCCMesh(parms.child("VCCMeshTopo", Map(
				("topoInCredits"->Soft(queueDepth)),
				("topoOutCredits"->Soft(queueDepth)),
			
				("rfCtor"->Soft((parms: Parameters) => new CMeshDOR(parms))),
				("routerCtor"->Soft((parms: Parameters) => new VCRouterWrapper(parms)))
		))))
        for (i <- 0 until numRouters) {
          topology.io.bypass(i) := io.bypass(i)
        }

		for (i <- 0 until numPorts) {
			val injectionQ = Chisel.Module( new InjectionChannelQ(parms.child(("InjectionQ", i), Map(
				("vcArbCtor"->Soft((parms: Parameters) => new RRArbiter(parms)))
			)) ) )
			val ejectionQ = Chisel.Module( new EjectionChannelQ(parms.child(("EjectionQ", i))) )
			val inputNetIface = Chisel.Module( new InputPacketInterface[T](parms.child(("inputNetIface", i)),tGen) )

			inputNetIface.io.in.bits := io.ports(i).in.packet 
			inputNetIface.io.in.valid := io.ports(i).in.packetValid
			io.ports(i).in.packetReady := inputNetIface.io.in.ready

			injectionQ.io.in <> inputNetIface.io.out

			// injectionQ.io.in.packet := io.ports(i).in.packet 
			// injectionQ.io.in.packetValid := io.ports(i).in.packetValid
			// io.ports(i).in.packetReady := injectionQ.io.in.packetReady
			topology.io.inChannels(i) <> injectionQ.io.out
			ejectionQ.io.in <> topology.io.outChannels(i)
			io.ports(i).out <> ejectionQ.io.out
		}
	    for (r <- 0 until numRouters) {
		    io.cyclesRouterBusy(r) := topology.io.cyclesRouterBusy(r)
    		for(c <- 0 until routerRadix) {
	    		io.cyclesChannelBusy((r*routerRadix) + c) := topology.io.cyclesChannelBusy((r*routerRadix) + c)
	    	}
    	}
	}
}

