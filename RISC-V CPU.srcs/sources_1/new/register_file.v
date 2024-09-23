module register_file (
    input clk,    
    input rst,           
    input regwrite,               
    input [4:0] read_addr1, 
    input [4:0] read_addr2, 
    input [4:0] write_addr, 
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2 
);

    reg [31:0] reg_file [0:31];
    integer i ;
    
    assign read_data1 = reg_file[read_addr1]; 
    assign read_data2 = reg_file[read_addr2]; 
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i=0; i<32; i=i+1) begin
                reg_file[i] <= 32'd0 ; 
            end
        end
        else if (regwrite)
            reg_file[write_addr] <= write_data; 
        else  reg_file[write_addr] <= reg_file[write_addr]; 
    end

endmodule
