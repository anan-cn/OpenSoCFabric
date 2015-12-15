`timescale 1ns/100ps
`define CLOCK_PERIOD 10

module test;
  reg [0:0] io_config_2_valid;
  reg [0:0] io_config_2_bits_sequence;
  reg [1:0] io_config_2_bits_destination_2;
  reg [1:0] io_config_2_bits_destination_1;
  reg [1:0] io_config_2_bits_destination_0;
  reg [31:0] io_config_2_bits_count;
  reg [0:0] io_config_1_valid;
  reg [0:0] io_config_1_bits_sequence;
  reg [1:0] io_config_1_bits_destination_2;
  reg [1:0] io_config_1_bits_destination_1;
  reg [1:0] io_config_1_bits_destination_0;
  reg [31:0] io_config_1_bits_count;
  reg [0:0] io_config_0_valid;
  reg [0:0] io_config_0_bits_sequence;
  reg [1:0] io_config_0_bits_destination_2;
  reg [1:0] io_config_0_bits_destination_1;
  reg [1:0] io_config_0_bits_destination_0;
  reg [31:0] io_config_0_bits_count;
  wire [0:0] io_config_2_ready;
  wire [0:0] io_config_1_ready;
  wire [0:0] io_config_0_ready;
  wire [31:0] io_count_2;
  wire [31:0] io_count_1;
  wire [31:0] io_count_0;
  wire [54:0] io_dump_2;
  wire [54:0] io_dump_1;
  wire [54:0] io_dump_0;
  reg io_bypass_2;
  reg io_bypass_1;
  reg io_bypass_0;

  reg reset;
  reg clk = 1;
  parameter clk_length = `CLOCK_PERIOD/2;
  always #clk_length clk = ~clk;
  /*** DUT instantiation ***/
    My_MeshWrapper
      My_MeshWrapper(
        .clk(clk),
        .reset(reset),
        .io_config_2_valid(io_config_2_valid),
        .io_config_2_bits_sequence(io_config_2_bits_sequence),
        .io_config_2_bits_destination_2(io_config_2_bits_destination_2),
        .io_config_2_bits_destination_1(io_config_2_bits_destination_1),
        .io_config_2_bits_destination_0(io_config_2_bits_destination_0),
        .io_config_2_bits_count(io_config_2_bits_count),
        .io_config_1_valid(io_config_1_valid),
        .io_config_1_bits_sequence(io_config_1_bits_sequence),
        .io_config_1_bits_destination_2(io_config_1_bits_destination_2),
        .io_config_1_bits_destination_1(io_config_1_bits_destination_1),
        .io_config_1_bits_destination_0(io_config_1_bits_destination_0),
        .io_config_1_bits_count(io_config_1_bits_count),
        .io_config_0_valid(io_config_0_valid),
        .io_config_0_bits_sequence(io_config_0_bits_sequence),
        .io_config_0_bits_destination_2(io_config_0_bits_destination_2),
        .io_config_0_bits_destination_1(io_config_0_bits_destination_1),
        .io_config_0_bits_destination_0(io_config_0_bits_destination_0),
        .io_config_0_bits_count(io_config_0_bits_count),
        .io_config_2_ready(io_config_2_ready),
        .io_config_1_ready(io_config_1_ready),
        .io_config_0_ready(io_config_0_ready),
        .io_count_2(io_count_2),
        .io_count_1(io_count_1),
        .io_count_0(io_count_0),
        .io_dump_2(io_dump_2),
        .io_dump_1(io_dump_1),
        .io_dump_0(io_dump_0),
        .io_bypass_2(io_bypass_2),
        .io_bypass_1(io_bypass_1),
        .io_bypass_0(io_bypass_0)
  );

  parameter flit_count = 100000;
  parameter clock_period = `CLOCK_PERIOD;
  parameter reset_period = `CLOCK_PERIOD * 4;
  initial begin
    io_config_2_valid = 0;
    io_config_2_bits_sequence = 0;
    io_config_2_bits_destination_2 = 0;
    io_config_2_bits_destination_1 = 0;
    io_config_2_bits_destination_0 = 0;
    io_config_2_bits_count = flit_count;

    io_config_1_valid = 0;
    io_config_1_bits_sequence = 0;
    io_config_1_bits_destination_2 = 0;
    io_config_1_bits_destination_1 = 0;
    io_config_1_bits_destination_0 = 1;
    io_config_1_bits_count = 0;

    io_config_0_valid = 0;
    io_config_0_bits_sequence = 0;
    io_config_0_bits_destination_2 = 0;
    io_config_0_bits_destination_1 = 0;
    io_config_0_bits_destination_0 = 2;
    io_config_0_bits_count = flit_count;
 
    io_bypass_0 = 0;
    io_bypass_1 = 1;
    io_bypass_2 = 0;

    reset = 1;
    #reset_period;
    reset = 0;

    #700;
    io_config_0_valid = 1;
    #10;
    io_config_0_valid = 0;
    
    #10;

    /*io_config_1_valid = 1;
    #(`CLOCK_PERIOD);
    io_config_1_valid = 0;
        
    #1000;*/

    io_config_2_valid = 1;
    #(`CLOCK_PERIOD);
    io_config_2_valid = 0;
    
    while (io_count_0 + io_count_2 != 4*flit_count) #(100 * `CLOCK_PERIOD);
    
    $finish;
  end

endmodule
