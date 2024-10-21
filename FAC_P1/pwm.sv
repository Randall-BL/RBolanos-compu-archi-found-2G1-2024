// PWM
// Velocidades
// 3 = 100% -> 11111111
// 2 = 75%  -> 11000000
// 1 = 50%  -> 10000000
// 0 = 25%  -> 01000000


//8'hFF: 11111111 (este es el valor hexadecimal FF, que representa 255 en decimal).
//8'hC0: 11000000 (este es el valor hexadecimal C0, que representa 192 en decimal).
//8'h80: 10000000 (este es el valor hexadecimal 80, que representa 128 en decimal).
//8'h40: 01000000 (este es el valor hexadecimal 40, que representa 64 en decimal)

// Completamente Estructural y Funcional

module pwm(
    input logic clk,
    input logic rst,
    input logic [1:0] speed,    // Velocidad de entrada de 2 bits
    output logic motor_pwm
);

    logic [7:0] count;
    logic [7:0] motor_speed;
    logic motor_on;

    // Asignar el valor de velocidad usando el operador ternario (ya cumple con la condición)
    assign motor_speed = (speed == 2'b11) ? 8'hFF :  // 100% -> 11111111
                         (speed == 2'b10) ? 8'hC0 :  // 75%  -> 11000000
                         (speed == 2'b01) ? 8'h80 :  // 50%  -> 10000000
                         8'h40;                      // 25%  -> 01000000

    // Contador estructural usando solo ecuaciones booleanas
    assign count = rst ? 8'h00 : 
                   (count == 8'hFF) ? 8'h00 : 
                   count + 1;

    // Comparar el contador con motor_speed para generar la señal PWM
    assign motor_on = (count < motor_speed);

    assign motor_pwm = motor_on;

endmodule


// PRUEBAS NO TOMAR EN CUENTA

// CON BLOQUE SECUENCIAL (FUNCIONA PERO NO SE DEBE USAR)
//module pwm(
//    input logic clk,
//    input logic rst,
//    input logic [1:0] speed,    // Velocidad de entrada de 2 bits
//    output logic motor_pwm
//);
//
//    logic [7:0] count;
//    logic [7:0] motor_speed;
//    logic motor_on;
//
//    // Asignar el valor de velocidad usando ecuaciones booleanas
//    assign motor_speed = (speed == 2'b11) ? 8'hFF :  // 100% -> 11111111
//                         (speed == 2'b10) ? 8'hC0 :  // 75%  -> 11000000
//                         (speed == 2'b01) ? 8'h80 :  // 50%  -> 01000000
//                         8'h40;                      // 25%  -> 00000000
//
//    // Contador SECUENCIAL ===> Se debe cambiar
//    always_ff @(posedge clk or posedge rst) begin
//        if (rst)
//            count <= 8'h00;
//        else if (count == 8'hFF)
//            count <= 8'h00;
//        else
//            count <= count + 1;
//    end
//
//    // Comparar el contador con motor_speed para generar la señal PWM
//    assign motor_on = (count < motor_speed);
//
//    assign motor_pwm = motor_on;
//
//endmodule

// CON FULL COMPUERTAS LOGICAS (NO FUNCIONA SEGUN LO ESPERADO)
//module pwm(
//    input logic clk,
//    input logic rst,
//    input logic [1:0] speed,    // Velocidad de entrada de 2 bits
//    output logic motor_pwm
//);
//
//    logic [7:0] count;
//    logic [7:0] motor_speed;
//    logic motor_on;
//
//    // Asignar el valor de velocidad usando ecuaciones booleanas
//    assign motor_speed[7] = speed[1] & speed[0]; // 100% (255)
//    assign motor_speed[6] = (~speed[1] & speed[0]) | (speed[1] & speed[0]); // 75% (192) y 100% (255)
//    assign motor_speed[5] = (~speed[1] & speed[0]) | (speed[1] & speed[0]); // 75% (192) y 100% (255)
//    assign motor_speed[4] = (~speed[1] & speed[0]) | (speed[1] & speed[0]); // 75% (192) y 100% (255)
//    assign motor_speed[3] = (~speed[1] & ~speed[0]) | motor_speed[6]; // 50%, 75%, 100%
//    assign motor_speed[2] = motor_speed[3];     // 50%, 75%, 100%
//    assign motor_speed[1] = motor_speed[3];     // 50%, 75%, 100%
//    assign motor_speed[0] = (~speed[1] & ~speed[0]) | motor_speed[3]; // 25%, 50%, 75%, 100%
//
//    // Lógica para el contador sin bloques de control
//    assign count = (!rst) ? 8'h00 : (count == 8'hFF) ? 8'h00 : count + 1;
//
//    // Comparar el contador con motor_speed para generar la señal PWM
//    assign motor_on = (count < motor_speed);
//
//    assign motor_pwm = motor_on;
//
//endmodule

