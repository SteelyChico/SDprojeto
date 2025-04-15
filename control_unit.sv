module control_unit (
    input [5:0] opcode,
    input [5:0] funct,
    output reg reg_write,
    output reg mem_to_reg,
    output reg mem_write,
    output reg [1:0] alu_op,
    output reg alu_src,
    output reg reg_dst
);
    always @(*) begin
        case (opcode)
            6'b000000: begin // Tipo-R (add, sub, and, or, slt, etc.)
                reg_dst = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_write = 1'b0;
                alu_op = 2'b10;
            end
            6'b100011: begin // lw
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_write = 1'b0;
                alu_op = 2'b00;
            end
            6'b101011: begin // sw
                reg_dst = 1'bx; // Não importa
                alu_src = 1'b1;
                mem_to_reg = 1'bx; // Não importa
                reg_write = 1'b0;
                mem_write = 1'b1;
                alu_op = 2'b00;
            end
            6'b001000: begin // addi
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_write = 1'b0;
                alu_op = 2'b00;
            end
            default: begin // Instrução não suportada ou nula
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b1; // Para o caso de instrução nula
                mem_write = 1'b0;
                alu_op = 2'b00;
            end
        endcase
    end
endmodule
