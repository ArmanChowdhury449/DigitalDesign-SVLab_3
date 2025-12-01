module alu (
    input  logic [3:0] opcode,
    input  logic [7:0] a, b,
    output logic [15:0] result
);
logic [15:0] temp_out;

always_comb begin
    case (opcode)
        4'b0001: begin
            temp_out = {1'b0, a} + {1'b0, b};
            result = temp_out[15:0];
        end
        4'b0010: begin
            temp_out = {1'b0, a} - {1'b0, b};
            result = temp_out[15:0];
        end
        4'b0011: begin
            temp_out = {1'b0, a} * {1'b0, b};
            result = temp_out[15:0];
        end
        default: result = 16'h0000;
    endcase
end
endmodule


