
//// ALU 2 BITS

module alu(
    input  logic [1:0] select,   // Selector de operación
    input  logic [1:0] a,        // Entrada A (2 bits)
    input  logic [1:0] b,        // Entrada B (2 bits)
    output logic [1:0] result,   // Resultado (2 bits)
    output Z, C, V, S            // Banderas: Zero, Carry, Overflow, Signo
);

// Almacenar los resultados de las operaciones
logic [1:0] sum;
logic [1:0] subs;
logic [1:0] andop;
logic [1:0] orop;

logic [1:0] res;  // Resultado final

logic Ct;  // Acarreo (Carry)
logic Vt;  // Desbordamiento (Overflow)
logic St;  // Signo (Signo)

// Instanciar módulos de operaciones
full_adder_2bit add(a, b, 0, sum, Ct);  // Suma (carry para suma)
substractor_2bit sub(a, b, subs, );     // Resta (carry ya no se usa para la resta)
ANDoperation_2bit andmodule(a, b, andop); // AND
ORoperation_2bit ormodule(a, b, orop);   // OR

// Multiplexor basado en ecuaciones booleanas para seleccionar la operación

// 00 SUM
// 01 SUB
// 10 AND
// 11	OR

assign res[0] = (((~select[1] & ~select[0]) & sum[0]) | ((~select[1] & select[0]) & subs[0]) | ((select[1] & ~select[0]) & andop[0]) | ((select[1] & select[0]) & orop[0]));
assign res[1] = (((~select[1] & ~select[0]) & sum[1]) | ((~select[1] & select[0]) & subs[1]) | ((select[1] & ~select[0]) & andop[1]) | ((select[1] & select[0]) & orop[1]));

// Banderas de estado
assign Z = (res == 2'b00);  // Zero: cuando el resultado es cero
assign C = ((~select[1] & ~select[0]) & Ct);  // Carry: solo es relevante en la suma

// Desbordamiento (Overflow): Para la suma y resta
assign V = (((~select[1] & ~select[0]) & ((a[1] & b[1] & ~sum[1]) | (~a[1] & ~b[1] & sum[1]))) | // Overflow en suma
            ((~select[1] &  select[0]) & ((a[1] & ~b[1] & ~subs[1]) | (~a[1] & b[1] & subs[1])))); // Overflow en resta

// Signo: Se toma el bit más significativo del resultado
assign S = res[1];

// Resultado final
assign result = res;

endmodule



//
//module alu(
//    input  logic [1:0] select,   // Selector de operación
//    input  logic [1:0] a,        // Entrada A (2 bits)
//    input  logic [1:0] b,        // Entrada B (2 bits)
//    output logic [1:0] result,   // Resultado (2 bits)
//    output Z, C, V, S            // Banderas: Zero, Carry, Overflow, Signo
//);
//
//// Almacenar los resultados de las operaciones
//logic [1:0] sum;
//logic [1:0] subs;
//logic [1:0] andop;
//logic [1:0] orop;
//
//logic [1:0] res;  // Resultado final
//
//logic Zt = 1'b0;  // Banderas inicializadas
//logic Ct;
//logic Vt = 1'b0;
//logic St;
//
//// Instanciar módulos de operaciones
//full_adder_2bit add(a, b, 0, sum, Ct);  // Suma
//substractor_2bit sub(a, b, subs, St);   // Resta
//ANDoperation_2bit andmodule(a, b, andop); // AND
//ORoperation_2bit ormodule(a, b, orop);   // OR
//
//// Multiplexor basado en ecuaciones booleanas para seleccionar la operación
//
//assign res[0] = (((~select[1] & ~select[0]) & sum[0]) | ((~select[1] & select[0]) & subs[0]) | ((select[1] & ~select[0]) & andop[0]) | ((select[1] & select[0]) & orop[0]));
//assign res[1] = (((~select[1] & ~select[0]) & sum[1]) | ((~select[1] & select[0]) & subs[1]) | ((select[1] & ~select[0]) & andop[1]) | ((select[1] & select[0]) & orop[1]));
//
//
////assign res[0] = ((~select[1] & ~select[0] & sum[0]) | 
////                 (~select[1] &  select[0] & subs[0]) | 
////                 ( select[1] & ~select[0] & andop[0]) | 
////                 ( select[1] &  select[0] & orop[0]));
////
////assign res[1] = ((~select[1] & ~select[0] & sum[1]) | 
////                 (~select[1] &  select[0] & subs[1]) | 
////                 ( select[1] & ~select[0] & andop[1]) | 
////                 ( select[1] &  select[0] & orop[1]));
//
//
//
//// Banderas de estado
//
//assign Z = (res == 2'b00);  // Zero
//assign C = Ct;              // Carry
//assign V = (((~select[1] & ~select[0]) & ((a[1] & b[1] & ~sum[1]) | (~a[1] & ~b[1] & sum[1]))) |
//             ((~select[1] & select[0]) & ((a[1] & ~b[1] & ~subs[1]) | (~a[1] & b[1] & subs[1]))));  // Overflow
//assign S = St;  // Signo (Negative)
//
//// Resultado final
//assign result = res;
//
//endmodule
