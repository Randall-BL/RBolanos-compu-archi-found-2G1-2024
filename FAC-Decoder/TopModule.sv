module TopModule (
    input A, B, C, D,   // Entradas para el primer decodificador
    input C2, D2,       // Entradas adicionales para el segundo decodificador
    input clk,          // Señal de reloj (clock) del botón
    input reset,        // Señal de reset
    output [6:0] seg    // Salida para el display de 7 segmentos
);

    // Señales intermedias para las salidas del primer decodificador
    wire Y0_first, Y1_first;
    
    // Señales intermedias para las salidas del segundo decodificador
    wire Y0_second, Y1_second;
    
    reg Y0_reg, Y1_reg;  // Registros para almacenar el resultado de Y0 y Y1 del segundo decodificador

    // Instancia del primer decodificador
    FirtsDecoder_4to2bits U1 (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y0(Y0_first),  // Y0 del primer decodificador
        .Y1(Y1_first)   // Y1 del primer decodificador
    );

    // Instancia del segundo decodificador, usando las salidas del primero como entradas
    Decoder_4To2bits U2 (
        .A(Y0_first),   // Conectamos Y0 del primer decodificador como A del segundo
        .B(Y1_first),   // Conectamos Y1 del primer decodificador como B del segundo
        .C(C2),         // C y D pueden ser otras señales o entradas adicionales
        .D(D2),
        .Y0(Y0_second), // Y0 del segundo decodificador
        .Y1(Y1_second), // Y1 del segundo decodificador
        .seg()          // No mostramos la salida en el display todavía
    );

    // Lógica para almacenar el resultado de Y0 y Y1 del segundo decodificador en el registro
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Y0_reg <= 1'b0;  // Reseteamos los registros si se presiona reset
            Y1_reg <= 1'b0;
        end else begin
            Y0_reg <= Y0_second;  // Almacenar los valores de Y0 del segundo decodificador en el registro
            Y1_reg <= Y1_second;  // Almacenar los valores de Y1 del segundo decodificador en el registro
        end
    end

    // Instancia del módulo bcd_to_7seg_2bits para mostrar el resultado en el display
    bcd_to_7seg_2bits U3 (
        .bcd({Y0_reg, Y1_reg}),  // Se conectan los registros como entrada al módulo de 7 segmentos
        .seg(seg)                // Salida para los 7 segmentos
    );

endmodule
