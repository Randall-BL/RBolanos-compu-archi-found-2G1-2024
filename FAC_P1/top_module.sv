

// MODULO PRINCIPAL

module top_module(
    input logic clk,
	 input wire clk_uart,
    input logic rst,
	 input logic rst_uart,
    input logic A, B, C, D,
	 input wire rx,
	 output wire tx,	 // Entradas para el decodificador (dedos)
    //input logic [1:0] alu_b,  // Entrada directa de la ALU
    input logic [1:0] alu_op,  // Selector de operación de la ALU
    output logic [6:0] seg1,   // Display de 7 segmentos para el resultado
    output logic motor_pwm,    // PWM para controlar el motor
    output logic [3:0] leds,    // LEDs para las banderas: Z, C, V, S
	 output logic [1:0] ledArduino
);

    logic [1:0] dec_result;   // Resultado del decodificador
    logic [1:0] alu_result;   // Resultado de la ALU
    logic [1:0] reg_out;      // Salida del registro
    logic Zero, Carry, Overflow, Negative;         // Señales de las banderas (Zero, Carry, Overflow, Signo)
	 logic reg_Zero, reg_Carry, reg_Overflow, reg_Negative; // Registros de las flags

	 
	 wire [7:0] uart_data_full_rx;  // Datos recibidos por UART (desde Arduino)
    wire [3:0] uart_data_rx;       // Solo los 4 bits menos significativos de los datos recibidos
    wire valid_rx;                 // Señal que indica que los datos recibidos son válidos
    reg [7:0] data_to_send;        // Datos que la FPGA enviará a través de UART
    reg send;                      // Señal para iniciar la transmisión
    reg valid_rx_d;                // Registro para almacenar valid anterior
	 
	 
	 
	 uart_rx uart_receiver (
        .clk(clk_uart),
        .rst_n(rst_uart),
        .rx(rx),
        .data(uart_data_full_rx),  // Dato completo de 8 bits recibido
        .valid(valid_rx)           // Señal de datos válidos
    );
	 
	 
	 // Procesamiento de datos y control de LEDs
	 assign uart_data_rx = uart_data_full_rx[3:0];
		
		
	 // Instancia del transmisor UART (TX)
    uart_tx uart_transmitter (
        .clk(clk_uart),
        .rst_n(rst_uart),
        .data_in(data_to_send),    // Dato que la FPGA enviará
        .send(send),               // Señal de transmisión
        .tx(tx),                   // Señal TX
        .busy()                    // Señal que indica si está ocupado
    );


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
        .b(uart_data_rx),
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
        .clk(clk_uart),
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
	 
	 
	// BLOQUE SECUENCIAL PARTE DE LA COMUNICACION UART
	 
	always @(posedge clk_uart or negedge rst_uart) begin
        if (!rst_uart) begin
            ledArduino <= 2'b00;            // Inicializar LEDs apagados
            data_to_send <= 8'b0;       // Inicializar dato a enviar
            send <= 0;                  // Inicializar señal de transmisión en 0
            valid_rx_d <= 0;            // Inicializar registro de valid
        end else begin
            valid_rx_d <= valid_rx;     // Almacenar la señal valid anterior
            
            // Si se detecta un flanco ascendente en valid_rx (nuevo dato recibido)
            if (valid_rx && !valid_rx_d) begin
                ledArduino <= uart_data_rx[1:0];  // Actualizar LEDs con los datos recibidos
                
                // Posponer el print para asegurar que los LEDs hayan sido actualizados
                #1 $display("Datos recibidos: %b, LEDs actualizados a: %b", uart_data_full_rx, ledArduino);
                
                // Preparar los datos a enviar al Arduino
                data_to_send <= uart_data_full_rx + 8'b1;  // Enviar un dato modificado
                send <= 1;  // Activar señal de transmisión
            end else begin
                send <= 0;  // Desactivar transmisión después de enviar el dato
            end
        end
    end
	
	

endmodule

