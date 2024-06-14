`timescale 1ns/ 1ps //standard clk is changed
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2023 11:23:43
// Design Name: 
// Module Name: step3
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
//to give user input data

module step3(
    input wire clk,
    input wire reset,
    input wire start,//when to start the i2c
    input wire [6:0] addr,
    input wire [7:0] data,
    output reg i2c_sda,
    output wire i2c_scl
    );
    // need to define local parameters
    localparam STATE_IDLE = 0;
    localparam STATE_START =1;
    localparam STATE_ADDR =2;
    localparam STATE_RW = 3;
    localparam STATE_WACK = 4;
    localparam STATE_DATA =5;
    localparam STATE_STOP = 6;
    localparam STATE_WACK2 = 7;
    // goal is to write to device address 0x50,0xaa
    //state machine is used 
    reg [7:0] state;// state machine shld have a state 
    //reg [6:0] addr; // to keep easy track of state and data as it was getting difficult(deleted from step 2)
    reg [7:0] count;
    //reg [7:0] data;(deleted from step 2)
    //making new regs to store the data and addr so its not dropped immediately
    reg [6:0] saved_addr;
    reg[7:0] saved_data;
    //
    reg i2c_scl_enable =0;//enable for scl
    //
    assign i2c_scl = (i2c_scl_enable ==0)?1: ~clk;
    
    // add another always block
    always @(negedge clk) begin 
        if (reset == 1) begin
            i2c_scl_enable <= 0;
        end
        else begin 
            if ((state == STATE_IDLE)||(state == STATE_START)||(state==STATE_STOP)) begin
                i2c_scl_enable <= 0;
            end
            else begin
                i2c_scl_enable <= 1;
            end
        end
    end
    // you dont use delays in synthesizable code 
    // the above always block defines the clk signle for i2c
    always @(posedge clk) begin 
        if (reset == 1) begin
            state <=0; //non blocking used for simpler logic level
            i2c_sda <=1; //initializing values in reset mode
            //i2c_scl <=1;(this statement becomes an error once the type of scl is changes to wire)
            //addr <= 7'h50;(deleted from step2)
            count <= 8'd0;
            //data<=8'haa;(deleted from step 2)
        end
        else begin 
            case (state)
                STATE_IDLE: begin //idle state
                    i2c_sda <=1; // idle state me sda 1 
                    //state <=STATE_START ; //idle state ke baad state will go to one
                    if (start) begin
                        state<=STATE_START;
                        saved_addr<=addr;
                        saved_data<=data;
                    end
                    else state<=STATE_IDLE;
                end
                STATE_START : begin // start state
                    i2c_sda <=0;
                    state <=STATE_ADDR; 
                    count <= 6;
                end
                STATE_ADDR : begin // well start sending the address 
                    //start with the 1st bit(most significant)
                    //i2c_sda <=0; //data was 0x50
                    //state <=3;
                    //improved version 
                    i2c_sda <= addr[count];
                    if (count ==0) state<=STATE_RW;
                    else count <= count-1;
                end
                
               // 3 :begin // 2nd msb bit
                //    i2c_sda <=1; //data was 0x50
                //    state <=4;
                //end
                //4 : begin
                  //  i2c_sda <=0; // 0x50 = 01010000
                   // state <=5; 
                //end 
                STATE_RW : begin
                    i2c_sda <= 1;
                    state <= STATE_WACK;
                end
                STATE_WACK : begin
                    // issue sda output me hai and output se read ni ho skta to it will create an issue
                    //just put state holder for time being
                    state <= STATE_DATA;
                    count <=7;
                end
                STATE_DATA :begin
                    i2c_sda <= data[count];
                    if (count == 0) state <= STATE_WACK2;//STATE_WACK;(creates infinite loop so declare 2wack)
                    else count <= count-1;   
                end
                STATE_WACK2 :begin
                    state<=STATE_STOP;
                end
                STATE_STOP :begin
                    i2c_sda<=1;
                    state<=STATE_IDLE;
                end
            endcase
        end 
    end
endmodule
