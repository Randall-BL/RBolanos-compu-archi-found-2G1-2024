
// OPERACION DE SUMA
// SUMADOR COMPLETO 2 BITS

module full_adder_2bit(
    input logic [1:0] a, b,
    input logic cin,
    output logic [1:0] sum,
    output logic cout
);

logic [1:0] c;
assign c[0] = cin;

unit_adder adder0(a[0], b[0], c[0], sum[0], c[1]);
unit_adder adder1(a[1], b[1], c[1], sum[1], cout);

endmodule
