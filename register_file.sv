module register_file (
    input clk,
    input we3,
    input [4:0] ra1, ra2, wa3,
    input [31:0] wd3,
    output [31:0] rd1, rd2,
    output [31:0] reg_8,
    output [31:0] reg_9,
    output [31:0] reg_10,
    output [31:0] reg_11
);
    reg [31:0] registers [0:31];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 0;
        end
    end
    
    // Leitura assíncrona
    assign rd1 = (ra1 != 0) ? registers[ra1] : 0;
    assign rd2 = (ra2 != 0) ? registers[ra2] : 0;
    
    // Escrita síncrona
    always @(posedge clk) begin
        if (we3 && wa3 != 0) begin
            registers[wa3] <= wd3;
        end
    end
    
    // Saídas para monitoramento
    assign reg_8 = registers[8]; // $t0
    assign reg_9 = registers[9]; // $t1
    assign reg_10 = registers[10]; // $t2
    assign reg_11 = registers[11]; // $t3
endmodule
