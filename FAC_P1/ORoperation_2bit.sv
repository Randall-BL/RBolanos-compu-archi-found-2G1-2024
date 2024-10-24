
// OPERACION OR

module ORoperation_2bit(
    input  logic [1:0] a,
    input  logic [1:0] b,
    output logic [1:0] result
);

assign result[0] = a[0] | b[0];
assign result[1] = a[1] | b[1];

endmodule
