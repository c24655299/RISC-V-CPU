`timescale 1ns / 1ps

module execution(
    input [31:0] alu1,
    input [31:0] alu2,
    input [3:0] alu_opt,
    output [31:0] alu_out,
    output zero
    );
    
    
    reg [31:0] alu_temp ; 
    assign alu_out = alu_temp ;
    assign zero = (alu_out == 32'd0 ) ? 1 : 0 ;  
    
    always@(*) begin 
        case(alu_opt) 
            4'b0000 : alu_temp = alu1 + alu2 ;          //ADD
            4'b0001 : alu_temp = alu1 - alu2 ;          //SUB
            4'b0010 : alu_temp = alu1 << alu2 ;         //SLL
            4'b0011 : alu_temp = (alu1 < alu2)?1:0 ;    //SLT
            4'b0100 : alu_temp = alu1 ^ alu2 ;          //XOR
            4'b0101 : alu_temp = alu1 >> alu2 ;         //SRL
            4'b0110 : alu_temp = alu1 | alu2 ;          //OR
            4'b0111 : alu_temp = alu1 & alu2 ;          //AND
            default : alu_temp = 32'hxxxx_xxxx ; 
        endcase
    end
endmodule
