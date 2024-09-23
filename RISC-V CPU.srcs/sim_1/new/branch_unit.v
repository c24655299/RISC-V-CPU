`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/19 14:23:30
// Design Name: 
// Module Name: branch_unit
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

module branch_unit(
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    input wire [2:0] branch_type,
    output reg taken
);
    always @(*) begin
        case (branch_type)
            3'b000: taken = (rs1_data == rs2_data);  // BEQ
            3'b001: taken = (rs1_data != rs2_data);  // BNE
            3'b100: taken = ($signed(rs1_data) < $signed(rs2_data));  // BLT
            3'b101: taken = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
            3'b110: taken = (rs1_data < rs2_data);  // BLTU
            3'b111: taken = (rs1_data >= rs2_data); // BGEU
            default: taken = 1'b0;
        endcase
    end
endmodule