`timescale 1ns / 1ps

module top_mod(
    input clk,
    input rst,
    output [31:0] pc,
    output [31:0] ins
    );
    
    wire [31:0] instruction ;
    wire [31:0] alu1 ; 
    wire [31:0] alu2 ; 
    wire [3:0] alu_opt ;
    wire [31:0] alu_out ;
    wire [31:0] write_dataM ; 
    wire [31:0] write_datareg ; 
    
    wire zero ; 
    wire jalr ; 
    wire branch ; 
    wire write_PC4 ; 
    wire alusrc ;
    wire mem2reg ; 
    wire regwrite ; 
    
    wire memread ; 
    wire memwrite ; 
    
    assign ins = instruction ; 
    instruction_fetch u0 ( 
        .clk(clk),
        .rst(rst),
        .jalr(jalr),
        .branch(branch),
        .jump_addr(alu_out),
        .pc(pc),
        .instruction(instruction)
    );
    
    instruction_decode u1 (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .write_datareg(write_datareg),
        .write_datapc(pc + 32'd4),
        .regwrite(regwrite),
        .alusrc(alusrc),
        .write_PC4(write_PC4),
        .data_a(alu1),
        .data_b(alu2),
        .write_dataM(write_dataM)
    );
    
    execution u2 ( 
        .alu1(alu1),
        .alu2(alu2),
        .alu_opt(alu_opt),
        .alu_out(alu_out),
        .zero(zero)
    );
    
    memory_access u3 ( 
        .clk(clk),
        .rst(rst),
        .data_in(write_dataM),
        .data_address(alu_out),
        .mem2reg(mem2reg),
        .memwrite(memwrite),
        .memread(memread),
        .read_data(write_datareg)
    );
    
    control u4 ( 
        .clk(clk),
        .rst(rst),
        .zero(zero),
        .instruction(instruction),
        .alu_opt(alu_opt),
        .branch(branch),
        .jalr(jalr),
        .write_PC4(write_PC4),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .memread(memread),
        .memwrite(memwrite),
        .regwrite(regwrite)
    );
endmodule