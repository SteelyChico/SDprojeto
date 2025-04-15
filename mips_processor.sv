module mips_processor (
    input clk,
    input reset,
    output [31:0] pc_out,
    output [31:0] instruction,
    output [31:0] alu_result,
    output [4:0] write_reg,
    output [31:0] reg_8,
    output [31:0] reg_9,
    output [31:0] reg_10,
    output [31:0] reg_11,
    output [5:0] opcode,
    output reg_write
);
    // Contador de programa
    wire [31:0] pc_next;
    reg [31:0] pc;
    
    // Banco de registradores
    wire [4:0] rs, rt, rd;
    wire [31:0] reg_data1, reg_data2, write_data;
    
    // Unidade de controle
    wire mem_to_reg, mem_write, branch, alu_src;
    wire [1:0] alu_op;
    wire [3:0] alu_control;
    wire reg_dst;
    
    // Memória
    wire [31:0] mem_read_data;
    
    // Extensor de sinal
    wire [15:0] imm;
    wire [31:0] sign_imm;
    
    // Outros fios
    wire [31:0] src_b, pc_plus4;
    wire zero;
    
    // Extração de campos da instrução
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign imm = instruction[15:0];
    
    // Lógica do PC
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc_next;
    end
    
    assign pc_plus4 = pc + 4;
    assign pc_next = pc_plus4; // Simplificado, sem branch
    assign pc_out = pc;
    
    // Memória de instruções
    instruction_memory instr_mem (
        .addr(pc),
        .instruction(instruction)
    );
    
    // Unidade de controle
    control_unit ctrl_unit (
        .opcode(opcode),
        .funct(instruction[5:0]),
        .reg_write(reg_write),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .reg_dst(reg_dst)
    );
    
    // ALU Control
    alu_control alu_ctrl (
        .alu_op(alu_op),
        .funct(instruction[5:0]),
        .alu_control(alu_control)
    );
    
    // Mux para selecionar registrador de destino (rd ou rt)
    assign write_reg = reg_dst ? rd : rt;
    
    // Banco de registradores
    register_file reg_file (
        .clk(clk),
        .we3(reg_write),
        .ra1(rs),
        .ra2(rt),
        .wa3(write_reg),
        .wd3(write_data),
        .rd1(reg_data1),
        .rd2(reg_data2),
        .reg_8(reg_8),
        .reg_9(reg_9),
        .reg_10(reg_10),
        .reg_11(reg_11)
    );
    
    // Extensão de sinal
    sign_extend sign_ext (
        .imm(imm),
        .sign_imm(sign_imm)
    );
    
    // Mux para entrada B da ALU
    assign src_b = alu_src ? sign_imm : reg_data2;
    
    // ALU
    alu main_alu (
        .a(reg_data1),
        .b(src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );
    
    // Memória de dados
    data_memory data_mem (
        .clk(clk),
        .we(mem_write),
        .addr(alu_result),
        .wd(reg_data2),
        .rd(mem_read_data)
    );
    
    // Mux para dados de escrita no banco de registradores
    assign write_data = mem_to_reg ? mem_read_data : alu_result;
    
endmodule
