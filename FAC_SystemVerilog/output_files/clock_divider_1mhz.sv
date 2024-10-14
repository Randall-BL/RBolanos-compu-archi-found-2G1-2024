module clock_divider_16mhz(
    input wire clk_in,       // Reloj de entrada (50 MHz)
    output reg clk_out       // Reloj de salida (16 MHz)
);

    // Dividir el reloj de 50 MHz para obtener aproximadamente 16 MHz.
    // 50 MHz / 16 MHz = 3.125. Usamos un divisor aproximado de 3 ciclos.
    reg [1:0] count = 0;     // Contador de 2 bits

    always @(posedge clk_in) begin
        count <= count + 1;
        if (count == 1) begin
            clk_out <= ~clk_out;  // Alternar la salida
            count <= 0;           // Reiniciar el contador
        end
    end
endmodule
