`timescale 1ns/1ps

module tb_top_mod (
);
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] ins;

    top_mod uut (
        .clk(clk),
        .rst(reset),
        .pc(pc),
        .ins(ins)
    );

    always #5 clk = ~clk;
    initial begin
        $dumpfile("riscv.vcd");
        $dumpvars(0, tb_top_mod);
        $monitor("PC = 0x%h, Instruction = %b", pc, ins);
        clk = 0;
        reset = 0;

        #1 reset = 1;
        #1 reset = 0;

        #200 $finish;
    end
endmodule
