module testbench;
    reg clk;
    reg reset;
    wire [31:0] pc_out, instruction, alu_result;
    wire [4:0] write_reg;
    wire [31:0] reg_8, reg_9, reg_10, reg_11;
    wire [5:0] opcode;
    wire reg_write;
    integer clock_cycles = 0;

    // Instanciação do processador MIPS
    mips_processor processor (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction(instruction),
        .alu_result(alu_result),
        .write_reg(write_reg),
        .reg_8(reg_8),
        .reg_9(reg_9),
        .reg_10(reg_10),
        .reg_11(reg_11),
        .opcode(opcode),
        .reg_write(reg_write)
    );

    // Geração de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Inicialização
    initial begin
        $dumpfile("mips_processor.vcd");
        $dumpvars(0, testbench);
        
        reset = 1;
        #5 reset = 0;        

        #60;
        
        // Mostrar conteúdo dos registradores
        $display("$t0 = %d", reg_8);
        $display("$t1 = %d", reg_9);
        $display("$t2 = %d", reg_10);
        $display("$t3 = %d", reg_11);
        
        $finish;
    end

    // Monitoramento dos sinais
    always @(posedge clk) begin
        clock_cycles = clock_cycles + 1;

        if (clock_cycles > 0) begin
            #1;
            $display("PC: %d, Instr: %h, $t0: %d, $t1: %d, $t2: %d, $t3: %d", 
                     pc_out, instruction, reg_8, reg_9, reg_10, reg_11);

            if (reg_write)
                $display("Escrevendo %d no registrador %d", alu_result, write_reg);
        end
    end
endmodule
