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

    reg [7:0] count;  // Uso de 'reg' para cumplir con la solicitud de registro en always
    logic [7:0] motor_speed;
    logic motor_on;

    // Asignar el valor de velocidad usando el operador ternario
    assign motor_speed = (speed == 2'b11) ? 8'hFF :  // 100% -> 11111111
                         (speed == 2'b10) ? 8'hC0 :  // 75%  -> 11000000
                         (speed == 2'b01) ? 8'h80 :  // 50%  -> 10000000
                         8'h40;                      // 25%  -> 01000000

    // Manejo del contador dentro del bloque always exclusivamente para registros
    always @(posedge clk or posedge rst) begin
        count <= rst ? 8'h00 :                        // Resetear a 0 si rst está activo
                  (count == 8'hFF) ? 8'h00 :          // Resetear a 0 si el contador llega a 255
                  count + 8'h01;                      // Incrementar en otro caso
    end

    // Comparar el contador con motor_speed para generar la señal PWM
    assign motor_on = (count < motor_speed);

    // La salida PWM refleja el estado de motor_on
    assign motor_pwm = motor_on;

endmodule

