module controller #(parameter WIDTH = 16,
            parameter INSTR_LEN = 20,
            parameter ADDR = 5) (
    input  logic        clk,
    input  logic        reset,
    input logic         go,
    input  logic [INSTR_LEN-1:0] instruction,
    input  logic        done,
    output logic        enable,
    output logic [ADDR-1:0]  pc = '0,
    output logic [3:0]  opcode,
    output logic [7:0]  a, b,
    output logic invalid_opcode
);

logic [2:0] state, next_state = 2'b00;

always_ff @(clk) begin
    if (reset) state <= 00;
    else state <= next_state;
end

always_comb begin
    case (state)
    2'b00: begin // wait for go
        enable = 1'b0;
        invalid_opcode = 1'b0;
        pc = pc;
        opcode = '0; // opcode doesnt matter because datapath is not enabled
        a = '0;
        b = '0;
        if (go) begin
            next_state = 2'b01;
        end
    end
    2'b01: begin // fetch instruction
        enable = 1'b0;
        invalid_opcode = 1'b0;
        opcode = '0;
        next_state = 2'b10;
    end
    2'b10: begin // get opcode, a, b
	pc++;
        enable = 1'b0;
        invalid_opcode = 1'b0;
        opcode = instruction[INSTR_LEN-1:16]; // opcode doesnt matter because datapath is not enabled
        a = instruction[15:8];
        b = instruction[7:0];
        pc = pc;
        if(opcode == 4'b1111) begin
            //next_state = 2'b00;
        end else if (opcode >= 4'b0100 && opcode != 4'b1011) begin
            invalid_opcode = 1'b1;
	    next_state = 2'b11;
        end else begin
            next_state = 2'b11;
        end
    end
    2'b11: begin // execute
        enable = 1'b1;
        invalid_opcode = 1'b0;
	opcode = opcode;
	a = a;
	b = b;
	pc = pc;
        if (done) begin
            next_state = 2'b00;
        end
    end
    endcase
end





endmodule










