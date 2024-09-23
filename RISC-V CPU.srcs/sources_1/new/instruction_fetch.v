`timescale 1ns / 1ps

module instruction_fetch(
    input clk,
    input rst,
    input jalr,
    input branch,
    input [31:0] jump_addr,
    output [31:0] pc,
    output [31:0] instruction
    );
    
    wire [31:0] branch_addr ; 
    wire [31:0] PC_offset;
    wire [6:0] opcode = instruction[6:0];
    wire [31:0] imm_B = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    wire [31:0] imm_J = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
    reg [31:0] pc_temp ; 
    
    assign PC_offset = (opcode == 7'b1101111) ? imm_J : imm_B;
    assign branch_addr = (jalr) ? jump_addr : (pc + PC_offset);  
    assign pc = pc_temp ; 
    
    instruction_mem u0 (
        .instruction_address(pc),
        .instruction(instruction)
    );
    
    // program counter 
    always@( posedge clk or posedge rst ) begin 
        if (rst) 
            pc_temp <= 32'd0 ; 
        else if (branch)
            pc_temp <= branch_addr ; 
        else begin
            pc_temp <= pc_temp + 32'd4 ; 
        end
    end
    
endmodule
