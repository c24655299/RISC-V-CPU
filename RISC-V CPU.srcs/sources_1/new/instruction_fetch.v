`timescale 1ns / 1ps

module instruction_fetch(
    input clk,
    input rst,
    output reg [31:0] pc,
    output reg [31:0] instruction
    );
    
    instruction_mem u0 (
        .instruction_address(pc),
        .instruction(instruction)
    );
    
    // program counter 
    always@( posedge clk or negedge rst ) begin 
        if (rst) begin
            pc <= 32'd0 ; 
        end
        else begin
            pc <= pc + 32'd4 ; 
        end
    end
    
endmodule
