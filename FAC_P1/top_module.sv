
// MODULO PRINCIPAL

module top_module(
    input logic clk,
    input logic rst,
    input logic A, B, C, D,    // Entradas para el decodificador (dedos)
    input logic [1:0] alu_b,   // Entrada directa de la ALU
    input logic [1:0] alu_op,  // Selector de operación de la ALU
    output logic [6:0] seg1,   // Display de 7 segmentos para el resultado
    output logic motor_pwm     // PWM para controlar el motor
);

    logic [1:0] dec_result;   // Resultado del decodificador
    logic [1:0] alu_result;   // Resultado de la ALU
    logic [1:0] reg_out;      // Salida del registro

    // Instancia del Decodificador
    FirtsDecoder_4to2bits decoder_inst (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y0(dec_result[1]),
        .Y1(dec_result[0])
    );

    // Instancia de la ALU
    alu alu_inst (
        .select(alu_op),
        .a(dec_result),
        .b(alu_b),
        .result(alu_result)
    );
	 
	 // Registro para almacenar el resultado de la ALU
    reg_2bit reg_inst (
        .clk(clk),
        .rst(rst),
        .d(alu_result),     // Entrada del registro es el resultado de la ALU
        .q(reg_out)         // Salida del registro
    );

    // Instancia del PWM, utilizando el resultado de la ALU como la velocidad
    pwm pwm_inst (
        .clk(clk),
        .rst(rst),
        .speed(reg_out),   // El resultado de la ALU y registro controla la velocidad del motor
        .motor_pwm(motor_pwm)
    );
	 
	 
	  bin_to_7seg result_to_7seg ( //Mostrar el resultado
        .bin(reg_out),
        .seg(seg1)
    );

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



