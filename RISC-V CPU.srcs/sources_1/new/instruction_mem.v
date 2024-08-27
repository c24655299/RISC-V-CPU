`timescale 1ns / 1ps

module instruction_mem(
    input [31:0] instruction_address,
    output [31:0] instruction
    );
    
    reg [31:0] Mem [0:16383];  // 16k * 32bit memeory

    assign instruction = Mem[instruction_address / 32'h4];

    initial begin
        $readmemb("instruction_data.txt", Mem);
    end
endmodule
