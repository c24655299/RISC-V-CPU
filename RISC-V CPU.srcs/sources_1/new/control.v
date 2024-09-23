`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/27 14:38:30
// Design Name: 
// Module Name: control
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


module control(
    input clk,
    input rst,
    input zero,
    input[31:0] instruction,
    output reg [3:0] alu_opt,
    output reg branch,
    output reg jalr,
    output reg write_PC4,
    output reg alusrc,
    output reg mem2reg,
    output reg memread,
    output reg memwrite,
    output reg regwrite
    
    );
    // define data type 
    parameter R_TYPE = 3'b000;
    parameter I_TYPE = 3'b001;
    parameter S_TYPE = 3'b010;
    parameter B_TYPE = 3'b011;
    parameter JUMP   = 3'b100;
    parameter UNKNOWN_TYPE = 3'b111;
    
    wire [6:0] opcode ; 
    wire [2:0] funct3 ; 
    wire [6:0] funct7 ; 
    
    reg [2:0] data_type_reg ; 
    
    assign data_type = data_type_reg ; 
        
    assign opcode = instruction[6:0] ; 
    assign funct3 = instruction[14:12] ; 
    assign funct7 = instruction[31:25] ; 
    
    always @( opcode or funct3 or funct7 ) begin 
        case (opcode)
            7'b0110011 : data_type_reg = R_TYPE ; 
            7'b0000011 : data_type_reg = I_TYPE ;   //lw
            7'b0010011 : data_type_reg = I_TYPE ;   //common I_type
            7'b1100111 : data_type_reg = I_TYPE ;   //JALR
            7'b0100011 : data_type_reg = S_TYPE ;   //sw
            7'b1100011 : data_type_reg = B_TYPE ; 
            7'b1101111 : data_type_reg = JUMP ;
            default  : data_type_reg = UNKNOWN_TYPE ; 
        endcase
    end 
    
   always @(opcode or funct3 or funct7) begin
        case (opcode)
           7'b0110011 : //  R_TYPE
                case ({funct7, funct3})
                   10'b0000000_000 : alu_opt = 4'b0000; // add
                   10'b0100000_000 : alu_opt = 4'b0001; // sub
                   10'b0000000_111 : alu_opt = 4'b0111; // and
                   10'b0000000_110 : alu_opt = 4'b0110; // or
                   10'b0000000_100 : alu_opt = 4'b0100; // xor
                   10'b0000000_001 : alu_opt = 4'b0010; // sll
                   10'b0000000_101 : alu_opt = 4'b0101; // srl
                    default: alu_opt = 4'bxxxx;
                endcase
           7'b0010011 : //   I_TYPE
                case ({funct3})
                   3'b000 : alu_opt = 4'b0000; // addi
                   3'b100 : alu_opt = 4'b0100; // xori
                   3'b110 : alu_opt = 4'b0110; // ori
                   3'b111 : alu_opt = 4'b0111; // andi
                   3'b001 : alu_opt = 4'b0010; // slli
                   3'b101 : alu_opt = 4'b0101; // srli
                    default: alu_opt = 4'bxxxx;
                endcase
           7'b0000011 : alu_opt = 4'b0000; // lw
           7'b0100011 : alu_opt = 4'b0000; // sw
           7'b1100111 : alu_opt = 4'b0000; // jalr
           7'b1101111 : alu_opt = 4'b0000; // jal
           7'b1100011 : alu_opt = 4'b0001; // beq¡Bbne¡Bblt¡Bbge
            default: alu_opt = 4'bxxxx;
        endcase
    end
        
    always @(data_type_reg) begin 
        branch = 0 ;
        jalr = 0 ; 
        write_PC4 = 0 ; 
        alusrc = 0 ; 
        mem2reg = 0 ; 
        memread = 0 ; 
        memwrite = 0 ; 
        regwrite = 0 ; 
        
        case (data_type_reg)
            R_TYPE : regwrite = 1 ; 
    
            I_TYPE : 
                case (opcode)
                    7'b0000011 : begin // lw
                        memread = 1 ; 
                        mem2reg = 1 ;
                        regwrite = 1 ; 
                        alusrc = 1 ; 
                    end
                    7'b0010011 : begin // commonI
                        regwrite = 1 ;    
                        alusrc = 1 ;
                    end
                    7'b1100111 : begin // JALR
                        jalr = 1 ; 
                        write_PC4 = 1 ; 
                    end
                    default : begin
                        regwrite = 1 ;    
                        alusrc = 1 ;
                    end
                endcase
    
            S_TYPE : begin             
                memwrite = 1 ;
                alusrc = 1 ;
            end
    
            B_TYPE : 
                case ({funct3, zero})
                    4'b000_1 : branch = 1; // beq
                    4'b001_0 : branch = 1; // bne
                    4'b100_0 : branch = 1; // blt
                    4'b101_0 : branch = 1; // bge (Á×§Kx)
                    default: branch = 0;
                endcase
    
            JUMP : begin
                jalr = 1 ;
                write_PC4 = 1 ;
            end
            
            default: begin
                $display("Error: UNKNOWN_TYPE detected for data_type_reg = %b", data_type_reg);
            end
        endcase
    end

    
    /*
    assign data_type = ( opcode == 7'b0110011 ) ? R_TYPE : 
                        ( opcode == 7'b0000011 ||  opcode == 7'b0010011) ? I_TYPE : 
                        ( opcode == 7'b0100011 ) ? S_TYPE : 
                        ( opcode == 7'b1100011 ) ? B_TYPE :
                        ( opcode == 7'b1100011 ) ? B_TYPE : 
                        ( opcode == 7'b1100011 ) ? JUMP : 3'd0 ;  
    */
    
endmodule
