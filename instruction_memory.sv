module instruction_memory (
    input [31:0] addr,
    output [31:0] instruction
);
    reg [31:0] mem [0:63];
    
    initial begin
        // Programa de exemplo com adição e subtração:
        // addi $t0, $zero, 8   # $t0 = 8
        mem[0] = 32'h20080008;
        // addi $t1, $zero, 3   # $t1 = 3
        mem[1] = 32'h20090003;
        // add $t2, $t0, $t1    # $t2 = $t0 + $t1 = 11
        mem[2] = 32'h01095020;
        // sub $t3, $t0, $t1    # $t3 = $t0 - $t1 = 5
        mem[3] = 32'h01095822;
        // sw $t2, 0($zero)     # Mem[0] = $t2 = 11
        mem[4] = 32'hac0a0000;
        // sw $t3, 4($zero)     # Mem[1] = $t3 = 5
        mem[5] = 32'hac0b0004;
    end
    
    assign instruction = mem[addr[31:2]]; // Converte endereço em palavras (divisão por 4)
endmodule
