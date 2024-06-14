`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2023 11:03:36
// Design Name: 
// Module Name: i2c_clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_clk_divider(
    input wire reset,
    input wire ref_clk,
    output reg i2c_clk
    );
    // fixing problem with sds and reset 
    //comment reset module
    initial i2c_clk = 0;
    //
    parameter DELAY = 1000;
    reg [9:0] count=0;
    always @(posedge ref_clk) begin
        //if (reset ==1) begin
          //  i2c_clk = 0;
          //  count = 0;
        //end
        //else begin 
            if (count ==((DELAY/2)-1)) begin//count up divider (500 liya cause t = T/2 pe change hoga signal) T = 1000
                i2c_clk = ~i2c_clk;
                count = 0;// we chose thousand kyun ki hmara desired 1ns ka hai and input 1us ka(100mhz se 100 khz)
            end
            else begin
                count = count+1;
            end
        //end
    end
    
endmodule
