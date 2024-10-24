module uart_tx (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire [7:0] data_in, // Dato de 8 bits a enviar
    input wire send,         // Señal para iniciar la transmisión
    output reg tx,           // Señal TX UART
    output reg busy          // Señal que indica si está transmitiendo
);

    // Parámetros de UART
    parameter CLK_FREQ = 50000000;  // Frecuencia del reloj del sistema (50 MHz)
    parameter BAUD_RATE = 9600;     // Baud rate de UART (9600)
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;  // Tiempo de un tick de UART

    reg [15:0] baud_count;   // Contador de ticks del baudrate
    reg [3:0] bit_count;     // Contador de bits transmitidos
    reg [9:0] shift_reg;     // Registro de desplazamiento de 10 bits (start, 8 datos, stop)
    reg transmitting;        // Indicador de si está transmitiendo

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1'b1;  // El pin TX es idle cuando está en alto
            baud_count <= 0;
            bit_count <= 0;
            busy <= 0;
            transmitting <= 0;
        end else if (send && !transmitting) begin
            // Iniciar la transmisión cuando se recibe la señal 'send'
            shift_reg <= {1'b1, data_in, 1'b0};  // Stop bit (1), data, Start bit (0)
            transmitting <= 1;
            busy <= 1;
            baud_count <= 0;
            bit_count <= 0;
        end else if (transmitting) begin
            if (baud_count == BAUD_TICK - 1) begin
                baud_count <= 0;
                tx <= shift_reg[0];  // Enviar el bit menos significativo (LSB)
                shift_reg <= {1'b1, shift_reg[9:1]};  // Desplazar los bits a la derecha
                bit_count <= bit_count + 1;
                
                if (bit_count == 9) begin
                    transmitting <= 0;
                    busy <= 0;
                    tx <= 1'b1;  // Idle después del bit de parada
                end
            end else begin
                baud_count <= baud_count + 1;
            end
        end
    end
endmodule

