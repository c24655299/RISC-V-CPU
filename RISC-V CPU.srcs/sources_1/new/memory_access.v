`timescale 1ns / 1ps

module memory_access(
    input clk,
    input rst, 
    input [31:0] data_in,
    input [31:0] data_address,
    input mem2reg, 
    input memwrite,
    input memread,
    output [31:0] read_data
    );
    
    reg [31:0] data_memory[0:31] ; 
    integer i ; 
    
    assign read_data = (mem2reg) ? data_memory[data_address] : data_address ; 
    
    always@(posedge clk or posedge rst) begin 
        if (rst) begin
            for(i=0; i<32; i=i+1) begin
                data_memory[i] <= 32'd0 ; 
            end
        end
        if (memwrite) data_memory[data_address] <= data_in ; 
        else data_memory[data_address] <= data_memory[data_address] ;
    end
    
endmodule
