
// MODULO PRINCIPAL

module top_module(
    input logic clk,
    input logic rst,
    input logic [1:0] alu_a,  // Entradas de la ALU
    input logic [1:0] alu_b,
    input logic [1:0] alu_op, // Selector de operación de la ALU
	 output logic [6:0] seg1, // 7 segmentos para resultado en display
    output logic motor_pwm    // Salida PWM para el motor
);

    logic [1:0] alu_result;  // Resultado de la ALU

    // Instancia de la ALU
    alu alu_inst (
        .select(alu_op),
        .a(alu_a),
        .b(alu_b),
        .result(alu_result)
    );

    // Instancia del PWM, utilizando el resultado de la ALU como la velocidad
    pwm pwm_inst (
        .clk(clk),
        .rst(rst),
        .speed(alu_result),   // El resultado de la ALU controla la velocidad del motor
        .motor_pwm(motor_pwm)
    );
	 
	 
	  bin_to_7seg result_to_7seg ( //Mostrar el resultado
        .bin(alu_result),
        .seg(seg1)
    );

endmodule
