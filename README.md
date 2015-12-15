Fall 2015 ECE 527 Research
==========================

The code present in this repository is a research project done for ECE 527
System-on-chip design. It explores methods for using clock gating with Xilinx 7-series
FPGAs using the NoC.

## Files in this repository ##

Most files in this repository are part of OpenSoC Fabric.
The following scala files were modified by us:
    src/main/scala/main.scala
    src/main/scala/router.scala
    src/main/scala/routerTester.scala
    src/main/scala/topology.scala

The file below contains our original code
    src/main/scala/mymesh.scala
    manual_edit/VCRouterBypass.v
    manual_edit/My_MeshWrapper-harness.v

The remaining file in `manual_edit` is a slightly modified form of the generated NoC.

## Reproducing our results ##

1. Extract the Vivado project `vivado_files/noc.xpr.zip`
2. Edit the testbench `My_MeshWrapper-harness.v` to enable or disable `io_bypass_1`
3. Run behavioral simulation.

  a. Use the following commands to get an saif:

```
restart
open_saif "A.saif"
log_saif [get_objects -r *]
run 30 us
close_saif
```

  b. Run synthesis and input the saif file to power analysis.


OpenSoC Fabric
========

## Abstract ##
Recent advancements in technology scaling have shown a trend towards greater integration with large-scale chips containing thousands of processors connected to memories and other I/O devices using non-trivial network topologies. Software simulation proves insufficient to study the tradeoffs in such complex systems due to slow execution time, whereas hardware RTL development is too time-consuming. We present *OpenSoC Fabric*, an on-chip network generation infrastructure which aims to provide a parameterizable and powerful on-chip network generator for evaluating future high performance computing architectures based on SoC technology. *OpenSoC Fabric* leverages a new hardware DSL, [Chisel](http://chisel.eecs.berkeley.edu/), which contains powerful abstractions provided by its base language, Scala, and generates both software (C++) and hardware (Verilog) models from a single code base. The *OpenSoC Fabric* infrastructure is modeled after existing state-of-the-art simulators, offers large and powerful collections of configuration options, and follows object-oriented design and functional programming to make functionality extension as easy as possible.

---
## Copyright ##
*OpenSoC Fabric*, Copyright (c) 2014, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy).  All rights reserved.

If you have questions about your rights to use or distribute this software, please contact Berkeley Lab's Technology Transfer Department at  TTD@lbl.gov.

NOTICE.  This software is owned by the U.S. Department of Energy.  As such, the U.S. Government has been granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, and perform publicly and display publicly.  Beginning five (5) years after the date permission to assert copyright is obtained from the U.S. Department of Energy, and subject to any subsequent five (5) year renewals, the U.S. Government is granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, distribute copies to the public, perform publicly and display publicly, and to permit others to do so.
