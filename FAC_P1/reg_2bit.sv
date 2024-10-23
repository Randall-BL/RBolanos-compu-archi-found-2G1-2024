// Registro de 2 bits controlado por reloj

module reg_2bit(
    input logic clk,
    input logic rst,         // Señal de reset
    input logic [1:0] d,     // Entrada de datos (resultado de la ALU)
    output logic [1:0] q     // Salida del registro
);

    always @(posedge clk or posedge rst) begin
        // Reset sin usar `if` ni `case`
        q[0] <= (rst) ? 1'b0 : d[0];  // Bit menos significativo
        q[1] <= (rst) ? 1'b0 : d[1];  // Bit más significativo
    end

endmodule
