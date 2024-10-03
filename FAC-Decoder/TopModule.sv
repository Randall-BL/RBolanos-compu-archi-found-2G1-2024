
//Modulo Principal: Contiene todas las instancias de los decodificadores, bcd y registro

module TopModule (
    input A, B, C, D,      // Entradas para el primer decodificador
    input C2, D2,          // Entradas para el segundo decodificador
    input clk,             // Señal de clock
    input reset,           // Señal de reset
    output [6:0] seg       // Salida para el display de 7 segmentos
);

    // Señales para las salidas del primer decodificador
    wire Y0_first, Y1_first;
	 
    // Señales para las salidas del segundo decodificador
    wire Y0_second, Y1_second;
	 
	 // Registros para las salidas del segundo decodificador
    reg Y0_reg, Y1_reg;    

    // Instancia del primer decodificador
    FirtsDecoder_4to2bits U1 (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y0(Y0_first),    // Y0 del primer decodificador
        .Y1(Y1_first)     // Y1 del primer decodificador
    );

    // Instancia del segundo decodificador, usando las salidas del primer decodificador como entradas
    Decoder_4To2bits U2 (
        .A(Y0_first),  		// Conectamos Y0 del primer decodificador como A del segundo
        .B(Y1_first),  		// Conectamos Y1 del primer decodificador como B del segundo
        .C(C2),        
        .D(D2),
        .Y0(Y0_second),  	// Y0 del segundo decodificador
        .Y1(Y1_second)   	// Y1 del segundo decodificador
    );

    // Registro para tomar las salidas del segundo decodificador controlado por clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Y0_reg <= 1'b0;
            Y1_reg <= 1'b0;
        end else begin
            Y0_reg <= Y0_second;
            Y1_reg <= Y1_second;
        end
    end

    // Módulo para convertir la salida a BCD y mostrarla en el display de 7 segmentos de la FPGA
    bcd_to_7seg_2bits U15 (
        .bcd({Y0_reg, Y1_reg}),  // Se conectan las salidas registradas del segundo decodificador
        .seg(seg)                
    );

endmodule
