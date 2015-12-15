`timescale 1ns/100ps
module VCRouterBypass (
    input clk, input reset,
    output io_clkOut,
    input io_bypass,
    input [54:0] io_x_inChannels_4_flit_x,
    input  io_x_inChannels_4_flitValid,
    output reg io_x_inChannels_4_credit_1_grant,
    output reg io_x_inChannels_4_credit_0_grant,
    input [54:0] io_x_inChannels_3_flit_x,
    input  io_x_inChannels_3_flitValid,
    output reg io_x_inChannels_3_credit_1_grant,
    output reg io_x_inChannels_3_credit_0_grant,
    input [54:0] io_x_inChannels_2_flit_x,
    input  io_x_inChannels_2_flitValid,
    output reg io_x_inChannels_2_credit_1_grant,
    output reg io_x_inChannels_2_credit_0_grant,
    input [54:0] io_x_inChannels_1_flit_x,
    input  io_x_inChannels_1_flitValid,
    output reg io_x_inChannels_1_credit_1_grant,
    output reg io_x_inChannels_1_credit_0_grant,
    input [54:0] io_x_inChannels_0_flit_x,
    input  io_x_inChannels_0_flitValid,
    output reg io_x_inChannels_0_credit_1_grant,
    output reg io_x_inChannels_0_credit_0_grant,
    output reg[54:0] io_x_outChannels_4_flit_x,
    output reg io_x_outChannels_4_flitValid,
    input  io_x_outChannels_4_credit_1_grant,
    input  io_x_outChannels_4_credit_0_grant,
    output reg[54:0] io_x_outChannels_3_flit_x,
    output reg io_x_outChannels_3_flitValid,
    input  io_x_outChannels_3_credit_1_grant,
    input  io_x_outChannels_3_credit_0_grant,
    output reg[54:0] io_x_outChannels_2_flit_x,
    output reg io_x_outChannels_2_flitValid,
    input  io_x_outChannels_2_credit_1_grant,
    input  io_x_outChannels_2_credit_0_grant,
    output reg[54:0] io_x_outChannels_1_flit_x,
    output reg io_x_outChannels_1_flitValid,
    input  io_x_outChannels_1_credit_1_grant,
    input  io_x_outChannels_1_credit_0_grant,
    output reg[54:0] io_x_outChannels_0_flit_x,
    output reg io_x_outChannels_0_flitValid,
    input  io_x_outChannels_0_credit_1_grant,
    input  io_x_outChannels_0_credit_0_grant,
    output[31:0] io_x_counters_1_counterVal,
    output[7:0] io_x_counters_1_counterIndex,
    output[31:0] io_x_counters_0_counterVal,
    output[7:0] io_x_counters_0_counterIndex,

    output [54:0] io_y_inChannels_4_flit_x,
    output  io_y_inChannels_4_flitValid,
    input io_y_inChannels_4_credit_1_grant,
    input io_y_inChannels_4_credit_0_grant,
    output [54:0] io_y_inChannels_3_flit_x,
    output  io_y_inChannels_3_flitValid,
    input io_y_inChannels_3_credit_1_grant,
    input io_y_inChannels_3_credit_0_grant,
    output [54:0] io_y_inChannels_2_flit_x,
    output  io_y_inChannels_2_flitValid,
    input io_y_inChannels_2_credit_1_grant,
    input io_y_inChannels_2_credit_0_grant,
    output [54:0] io_y_inChannels_1_flit_x,
    output  io_y_inChannels_1_flitValid,
    input io_y_inChannels_1_credit_1_grant,
    input io_y_inChannels_1_credit_0_grant,
    output [54:0] io_y_inChannels_0_flit_x,
    output  io_y_inChannels_0_flitValid,
    input io_y_inChannels_0_credit_1_grant,
    input io_y_inChannels_0_credit_0_grant,
    input[54:0] io_y_outChannels_4_flit_x,
    input io_y_outChannels_4_flitValid,
    output  io_y_outChannels_4_credit_1_grant,
    output  io_y_outChannels_4_credit_0_grant,
    input[54:0] io_y_outChannels_3_flit_x,
    input io_y_outChannels_3_flitValid,
    output  io_y_outChannels_3_credit_1_grant,
    output  io_y_outChannels_3_credit_0_grant,
    input[54:0] io_y_outChannels_2_flit_x,
    input io_y_outChannels_2_flitValid,
    output  io_y_outChannels_2_credit_1_grant,
    output  io_y_outChannels_2_credit_0_grant,
    input[54:0] io_y_outChannels_1_flit_x,
    input io_y_outChannels_1_flitValid,
    output  io_y_outChannels_1_credit_1_grant,
    output  io_y_outChannels_1_credit_0_grant,
    input[54:0] io_y_outChannels_0_flit_x,
    input io_y_outChannels_0_flitValid,
    output  io_y_outChannels_0_credit_1_grant,
    output  io_y_outChannels_0_credit_0_grant,
    input[31:0] io_y_counters_1_counterVal,
    input[7:0] io_y_counters_1_counterIndex,
    input[31:0] io_y_counters_0_counterVal,
    input[7:0] io_y_counters_0_counterIndex
);
    reg io_reg_inChannels_4_credit_1_grant;
    reg io_reg_inChannels_4_credit_0_grant;
    reg io_reg_inChannels_3_credit_1_grant;
    reg io_reg_inChannels_3_credit_0_grant;
    reg io_reg_inChannels_2_credit_1_grant;
    reg io_reg_inChannels_2_credit_0_grant;
    reg io_reg_inChannels_1_credit_1_grant;
    reg io_reg_inChannels_1_credit_0_grant;
    reg io_reg_inChannels_0_credit_1_grant;
    reg io_reg_inChannels_0_credit_0_grant;
    reg [54:0] io_reg_outChannels_4_flit_x;
    reg io_reg_outChannels_4_flitValid;
    reg [54:0] io_reg_outChannels_3_flit_x;
    reg io_reg_outChannels_3_flitValid;
    reg [54:0] io_reg_outChannels_2_flit_x;
    reg io_reg_outChannels_2_flitValid;
    reg [54:0] io_reg_outChannels_1_flit_x;
    reg io_reg_outChannels_1_flitValid;
    reg [54:0] io_reg_outChannels_0_flit_x;
    reg io_reg_outChannels_0_flitValid;

    always @(posedge clk)
    begin
        io_reg_inChannels_4_credit_1_grant <= io_x_outChannels_4_credit_1_grant;
        io_reg_inChannels_4_credit_0_grant <= io_x_outChannels_4_credit_0_grant;
        io_reg_inChannels_3_credit_1_grant <= io_x_outChannels_3_credit_1_grant;
        io_reg_inChannels_3_credit_0_grant <= io_x_outChannels_3_credit_0_grant;
        io_reg_inChannels_2_credit_1_grant <= io_x_outChannels_2_credit_1_grant;
        io_reg_inChannels_2_credit_0_grant <= io_x_outChannels_2_credit_0_grant;
        io_reg_inChannels_1_credit_1_grant <= io_x_outChannels_1_credit_1_grant;
        io_reg_inChannels_1_credit_0_grant <= io_x_outChannels_1_credit_0_grant;
        io_reg_inChannels_0_credit_1_grant <= io_x_outChannels_0_credit_1_grant;
        io_reg_inChannels_0_credit_0_grant <= io_x_outChannels_0_credit_0_grant;
        io_reg_outChannels_4_flit_x <= io_x_inChannels_4_flit_x;
        io_reg_outChannels_4_flitValid <= io_x_inChannels_4_flitValid;
        io_reg_outChannels_3_flit_x <= io_x_inChannels_3_flit_x;
        io_reg_outChannels_3_flitValid <= io_x_inChannels_3_flitValid;
        io_reg_outChannels_2_flit_x <= io_x_inChannels_2_flit_x;
        io_reg_outChannels_2_flitValid <= io_x_inChannels_2_flitValid;
        io_reg_outChannels_1_flit_x <= io_x_inChannels_1_flit_x;
        io_reg_outChannels_1_flitValid <= io_x_inChannels_1_flitValid;
        io_reg_outChannels_0_flit_x <= io_x_inChannels_0_flit_x;
        io_reg_outChannels_0_flitValid <= io_x_inChannels_0_flitValid;
    end

    always @(*)
    begin
        if (io_bypass) begin
            io_x_inChannels_4_credit_1_grant = io_reg_inChannels_4_credit_1_grant;
            io_x_inChannels_4_credit_0_grant = io_reg_inChannels_4_credit_0_grant;
            io_x_inChannels_3_credit_1_grant = io_reg_inChannels_3_credit_1_grant;
            io_x_inChannels_3_credit_0_grant = io_reg_inChannels_3_credit_0_grant;
            io_x_inChannels_2_credit_1_grant = io_reg_inChannels_2_credit_1_grant;
            io_x_inChannels_2_credit_0_grant = io_reg_inChannels_2_credit_0_grant;
            io_x_inChannels_1_credit_1_grant = io_reg_inChannels_1_credit_1_grant;
            io_x_inChannels_1_credit_0_grant = io_reg_inChannels_1_credit_0_grant;
            io_x_inChannels_0_credit_1_grant = io_reg_inChannels_0_credit_1_grant;
            io_x_inChannels_0_credit_0_grant = io_reg_inChannels_0_credit_0_grant;
            io_x_outChannels_4_flit_x = io_reg_outChannels_4_flit_x;
            io_x_outChannels_4_flitValid = io_reg_outChannels_4_flitValid;
            io_x_outChannels_3_flit_x = io_reg_outChannels_3_flit_x;
            io_x_outChannels_3_flitValid = io_reg_outChannels_3_flitValid;
            io_x_outChannels_2_flit_x = io_reg_outChannels_2_flit_x;
            io_x_outChannels_2_flitValid = io_reg_outChannels_2_flitValid;
            io_x_outChannels_1_flit_x = io_reg_outChannels_1_flit_x;
            io_x_outChannels_1_flitValid = io_reg_outChannels_1_flitValid;
            io_x_outChannels_0_flit_x = io_reg_outChannels_0_flit_x;
            io_x_outChannels_0_flitValid = io_reg_outChannels_0_flitValid;
        end
        else begin
            io_x_inChannels_4_credit_1_grant = io_y_inChannels_4_credit_1_grant;
            io_x_inChannels_4_credit_0_grant = io_y_inChannels_4_credit_0_grant;
            io_x_inChannels_3_credit_1_grant = io_y_inChannels_3_credit_1_grant;
            io_x_inChannels_3_credit_0_grant = io_y_inChannels_3_credit_0_grant;
            io_x_inChannels_2_credit_1_grant = io_y_inChannels_2_credit_1_grant;
            io_x_inChannels_2_credit_0_grant = io_y_inChannels_2_credit_0_grant;
            io_x_inChannels_1_credit_1_grant = io_y_inChannels_1_credit_1_grant;
            io_x_inChannels_1_credit_0_grant = io_y_inChannels_1_credit_0_grant;
            io_x_inChannels_0_credit_1_grant = io_y_inChannels_0_credit_1_grant;
            io_x_inChannels_0_credit_0_grant = io_y_inChannels_0_credit_0_grant;
            io_x_outChannels_4_flit_x = io_y_outChannels_4_flit_x;
            io_x_outChannels_4_flitValid = io_y_outChannels_4_flitValid;
            io_x_outChannels_3_flit_x = io_y_outChannels_3_flit_x;
            io_x_outChannels_3_flitValid = io_y_outChannels_3_flitValid;
            io_x_outChannels_2_flit_x = io_y_outChannels_2_flit_x;
            io_x_outChannels_2_flitValid = io_y_outChannels_2_flitValid;
            io_x_outChannels_1_flit_x = io_y_outChannels_1_flit_x;
            io_x_outChannels_1_flitValid = io_y_outChannels_1_flitValid;
            io_x_outChannels_0_flit_x = io_y_outChannels_0_flit_x;
            io_x_outChannels_0_flitValid = io_y_outChannels_0_flitValid;
        end
    end

    /*assign io_x_inChannels_4_credit_1_grant = io_y_inChannels_4_credit_1_grant;
    assign io_x_inChannels_4_credit_0_grant = io_y_inChannels_4_credit_0_grant;
    assign io_x_inChannels_3_credit_1_grant = io_y_inChannels_3_credit_1_grant;
    assign io_x_inChannels_3_credit_0_grant = io_y_inChannels_3_credit_0_grant;
    assign io_x_inChannels_2_credit_1_grant = io_y_inChannels_2_credit_1_grant;
    assign io_x_inChannels_2_credit_0_grant = io_y_inChannels_2_credit_0_grant;
    assign io_x_inChannels_1_credit_1_grant = io_y_inChannels_1_credit_1_grant;
    assign io_x_inChannels_1_credit_0_grant = io_y_inChannels_1_credit_0_grant;
    assign io_x_inChannels_0_credit_1_grant = io_y_inChannels_0_credit_1_grant;
    assign io_x_inChannels_0_credit_0_grant = io_y_inChannels_0_credit_0_grant;
    assign io_x_outChannels_4_flit_x = io_y_outChannels_4_flit_x;
    assign io_x_outChannels_4_flitValid = io_y_outChannels_4_flitValid;
    assign io_x_outChannels_3_flit_x = io_y_outChannels_3_flit_x;
    assign io_x_outChannels_3_flitValid = io_y_outChannels_3_flitValid;
    assign io_x_outChannels_2_flit_x = io_y_outChannels_2_flit_x;
    assign io_x_outChannels_2_flitValid = io_y_outChannels_2_flitValid;
    assign io_x_outChannels_1_flit_x = io_y_outChannels_1_flit_x;
    assign io_x_outChannels_1_flitValid = io_y_outChannels_1_flitValid;
    assign io_x_outChannels_0_flit_x = io_y_outChannels_0_flit_x;
    assign io_x_outChannels_0_flitValid = io_y_outChannels_0_flitValid;*/
    assign io_x_counters_1_counterVal = io_y_counters_1_counterVal;
    assign io_x_counters_1_counterIndex = io_y_counters_1_counterIndex;
    assign io_x_counters_0_counterVal = io_y_counters_0_counterVal;
    assign io_x_counters_0_counterIndex = io_y_counters_0_counterIndex;

    assign io_y_inChannels_4_flit_x = io_x_inChannels_4_flit_x;
    assign io_y_inChannels_4_flitValid = io_x_inChannels_4_flitValid;
    assign io_y_inChannels_3_flit_x = io_x_inChannels_3_flit_x;
    assign io_y_inChannels_3_flitValid = io_x_inChannels_3_flitValid;
    assign io_y_inChannels_2_flit_x = io_x_inChannels_2_flit_x;
    assign io_y_inChannels_2_flitValid = io_x_inChannels_2_flitValid;
    assign io_y_inChannels_1_flit_x = io_x_inChannels_1_flit_x;
    assign io_y_inChannels_1_flitValid = io_x_inChannels_1_flitValid;
    assign io_y_inChannels_0_flit_x = io_x_inChannels_0_flit_x;
    assign io_y_inChannels_0_flitValid = io_x_inChannels_0_flitValid;
    assign io_y_outChannels_4_credit_1_grant = io_x_outChannels_4_credit_1_grant;
    assign io_y_outChannels_4_credit_0_grant = io_x_outChannels_4_credit_0_grant;
    assign io_y_outChannels_3_credit_1_grant = io_x_outChannels_3_credit_1_grant;
    assign io_y_outChannels_3_credit_0_grant = io_x_outChannels_3_credit_0_grant;
    assign io_y_outChannels_2_credit_1_grant = io_x_outChannels_2_credit_1_grant;
    assign io_y_outChannels_2_credit_0_grant = io_x_outChannels_2_credit_0_grant;
    assign io_y_outChannels_1_credit_1_grant = io_x_outChannels_1_credit_1_grant;
    assign io_y_outChannels_1_credit_0_grant = io_x_outChannels_1_credit_0_grant;
    assign io_y_outChannels_0_credit_1_grant = io_x_outChannels_0_credit_1_grant;
    assign io_y_outChannels_0_credit_0_grant = io_x_outChannels_0_credit_0_grant;

    //assign io_clkOut = ~io_bypass & clk;

    BUFHCE U_clk (.I(clk), .O(io_clkOut), .CE(~io_bypass));

endmodule

