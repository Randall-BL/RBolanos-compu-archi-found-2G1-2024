
// MODULO PRINCIPAL

// MODULO PRINCIPAL

module top_module(
    input logic clk,
    input logic rst,
    input logic A, B, C, D,    // Entradas para el decodificador (dedos)
    input logic [1:0] alu_b,   // Entrada directa de la ALU
    input logic [1:0] alu_op,  // Selector de operación de la ALU
    output logic [6:0] seg1,   // Display de 7 segmentos para el resultado
    output logic motor_pwm,    // PWM para controlar el motor
    output logic [3:0] leds    // LEDs para las banderas: Z, C, V, S
);

    logic [1:0] dec_result;   // Resultado del decodificador
    logic [1:0] alu_result;   // Resultado de la ALU
    logic [1:0] reg_out;      // Salida del registro
    logic Zero, Carry, Overflow, Negative;         // Señales de las banderas (Zero, Carry, Overflow, Signo)
	 logic reg_Zero, reg_Carry, reg_Overflow, reg_Negative; // Registros de las flags


    // Instancia del Decodificador
    FirtsDecoder_4to2bits decoder_inst (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y0(dec_result[0]),
        .Y1(dec_result[1])
    );

    // Instancia de la ALU
    alu alu_inst (
        .select(alu_op),
        .a(dec_result),
        .b(alu_b),
        .result(alu_result),
        .Z(Zero),   // Banderas conectadas
        .C(Carry),
        .V(Overflow),
        .S(Negative)
    );
	 
	 // Registro para almacenar el resultado de la ALU
    reg_2bit reg_inst (
        .clk(clk),
        .rst(rst),
        .d(alu_result),     // Entrada del registro es el resultado de la ALU
        .q(reg_out)         // Salida del registro
    );
	 
	 // Registro para las flags de la ALU 
	 always @(posedge clk or posedge rst) begin
		// Reset explícito controlado por el reloj
		 reg_Zero <= rst | Zero;        // Si rst es 1, la salida es 0. Si no, sigue Zero.
		 reg_Carry <= rst | Carry;
		 reg_Overflow <= rst | Overflow;
		 reg_Negative <= rst | Negative;
	 end

    // Instancia del PWM, utilizando el resultado de la ALU como la velocidad
    pwm pwm_inst (
        .clk(clk),
        .rst(rst),
        .speed(reg_out),   // El resultado de la ALU y registro controla la velocidad del motor
        .motor_pwm(motor_pwm)
    );
	 
	 // Convertidor binario a display de 7 segmentos para el resultado
     bin_to_7seg result_to_7seg (
        .bin(reg_out),
        .seg(seg1)
    );

    // Conexión de las banderas (Z, C, V, S) a los LEDs
    assign leds[0] = reg_Zero;  // LED para Zero flag
    assign leds[1] = reg_Carry;  // LED para Carry flag
    assign leds[2] = reg_Overflow;  // LED para Overflow flag
    assign leds[3] = reg_Negative;  // LED para Sign flag

endmodule




//// MODULO PRINCIPAL
//
//module top_module(
//    input logic clk,
//    input logic rst,
//    input logic [1:0] alu_a,  // Entradas de la ALU
//    input logic [1:0] alu_b,
//    input logic [1:0] alu_op, // Selector de operación de la ALU
//	 output logic [6:0] seg1, // 7 segmentos para resultado en display
//    output logic motor_pwm    // Salida PWM para el motor
//);
//
//    logic [1:0] alu_result;  // Resultado de la ALU
//
//    // Instancia de la ALU
//    alu alu_inst (
//        .select(alu_op),
//        .a(alu_a),
//        .b(alu_b),
//        .result(alu_result)
//    );
//
//    // Instancia del PWM, utilizando el resultado de la ALU como la velocidad
//    pwm pwm_inst (
//        .clk(clk),
//        .rst(rst),
//        .speed(alu_result),   // El resultado de la ALU controla la velocidad del motor
//        .motor_pwm(motor_pwm)
//    );
//	 
//	 
//	  bin_to_7seg result_to_7seg ( //Mostrar el resultado
//        .bin(alu_result),
//        .seg(seg1)
//    );
//
//endmodule



