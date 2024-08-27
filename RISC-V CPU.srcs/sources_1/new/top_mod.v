`timescale 1ns / 1ps

module top_mod(
    input clk,
    input rst,
    output [31:0] pc,
    output [31:0] ins
    );
    
    wire [31:0] instruction ;
    wire [31:0] alu_a ; 
    wire [31:0] alu_b ; 
    wire [31:0] alu_output ; 
    wire [31:0] data_mem ;
    
    instruction_fetch u0 ( 
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instruction(instruction)
    );
    
    instruction_decode u1 (
        .clk(clk),
        .rst(rst),
    );
    
    execution u2 ( 
        .clk(clk),
        .rst(rst),
    );
    
    memory_access u3 ( 
        .clk(clk),
        .rst(rst),
    );
    
    write_back u4 ( 
        .clk(clk),
        .rst(rst),
        
    );
    
    control u5 ( 
        .clk(clk),
        .rst(rst),
    );
endmodule
: