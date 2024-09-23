`timescale 1ns / 1ps

module instruction_decode(
    input clk,
    input rst,
    input[31:0] instruction,
    input [31:0] write_datareg,
    input [31:0] write_datapc,
    input regwrite,
    input alusrc,
    input write_PC4,
    output[31:0] data_a,
    output[31:0] data_b,
    output[31:0] write_dataM
    );
    
    wire [6:0] opcode ; 
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] read_data_a;
    wire [31:0] read_data_b;
    wire [31:0] write_data; 
    wire [31:0] imm_out ; 
    wire [11:0] imm_in ; 
    wire [11:0] imm_I ; 
    wire [11:0] imm_S ; 
    wire [11:0] imm_B ;
    
    assign rs1 = instruction[19:15] ; 
    assign rs2 = instruction[24:20] ; 
    assign rd = instruction[11:7] ; 
    assign opcode = instruction[6:0] ; 
    assign imm_I = instruction[31:20] ; 
    assign imm_S = {instruction[31:25],instruction[11:7]} ; 
    assign imm_B = {instruction[31],instruction[7],instruction[30:25],instruction[11:8]} ; 
    
    assign data_a = read_data_a ;  
    assign write_dataM = read_data_b ; 
    assign write_data = (write_PC4) ? write_datapc : write_datareg ; 
    assign data_b = (alusrc) ? imm_out : read_data_b;
    assign imm_in = (opcode == 7'b0100011) ? imm_S : (opcode == 7'b1100011)  ? imm_B : imm_I ; 
    
    register_file u0 (
        .clk(clk),    
        .rst(rst),           
        .regwrite(regwrite),               
        .read_addr1(rs1), 
        .read_addr2(rs2),
        .write_addr(rd), 
        .write_data(write_data),
        .read_data1(read_data_a),
        .read_data2(read_data_b) 
    );
    
    imm_gen u1(
        .imm_in(imm_in),
        .imm_out(imm_out)
    );
    
endmodule
