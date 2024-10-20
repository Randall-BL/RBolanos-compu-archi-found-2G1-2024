module uart_rx (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire rx,           // Señal de entrada RX (UART)
    output reg [1:0] data,   // Datos recibidos (2 bits)
    output reg valid,        // Señal de datos válidos
    // Señales adicionales para depuración en simulación
    output wire state_idle,
    output wire state_start,
    output wire state_data,
    output wire state_stop,
    output wire [15:0] baud_count,
    output wire bit_count,
    output wire [1:0] shift_reg
);

    // Parámetros para UART
    parameter CLK_FREQ = 50000000;          // Frecuencia de reloj (50 MHz)
    parameter BAUD_RATE = 9600;             // Velocidad de UART
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;       // Ticks por bit
    localparam BAUD_TICK_HALF = BAUD_TICK / 2;         // Mitad de BAUD_TICK

    // Estados de la máquina (one-hot encoding)
    reg state_idle_reg;
    reg state_start_reg;
    reg state_data_reg;
    reg state_stop_reg;

    // Registros y contadores
    reg [15:0] baud_count_reg;
    reg bit_count_reg;
    reg [1:0] shift_reg_reg;

    // Señales auxiliares
    wire baud_count_max;      // Indica que baud_count ha alcanzado BAUD_TICK - 1
    wire baud_count_half;     // Indica que baud_count ha alcanzado BAUD_TICK_HALF - 1
    wire bit_count_max;       // Indica que bit_count ha alcanzado su máximo (1)
    wire rx_low;              // Señal rx invertida

    // Asignaciones auxiliares
    assign baud_count_max = (baud_count_reg == BAUD_TICK - 1);
    assign baud_count_half = (baud_count_reg == BAUD_TICK_HALF - 1);
    assign bit_count_max = bit_count_reg;
    assign rx_low = ~rx;

    // Exposición de señales internas para depuración
    assign state_idle  = state_idle_reg;
    assign state_start = state_start_reg;
    assign state_data  = state_data_reg;
    assign state_stop  = state_stop_reg;
    assign baud_count  = baud_count_reg;
    assign bit_count   = bit_count_reg;
    assign shift_reg   = shift_reg_reg;

    // Señales de siguiente estado y valores siguientes
    wire state_idle_next;
    wire state_start_next;
    wire state_data_next;
    wire state_stop_next;
    wire [15:0] baud_count_next;
    wire bit_count_next;
    wire [1:0] shift_reg_next;
    wire [1:0] data_next;
    wire valid_next;

    // Lógica de transición de estados sin 'if', 'case' ni '?'
    assign state_idle_next = (state_idle_reg & ~rx_low) |
                             (state_stop_reg & baud_count_max) |
                             (~rst_n);

    assign state_start_next = (state_idle_reg & rx_low) |
                              (state_start_reg & ~baud_count_half);

    assign state_data_next = (state_start_reg & baud_count_half) |
                             (state_data_reg & ~(baud_count_max & bit_count_max));

    assign state_stop_next = (state_data_reg & baud_count_max & bit_count_max) |
                             (state_stop_reg & ~baud_count_max);

    // Lógica del contador de baudios
    wire baud_count_enable = state_start_reg | state_data_reg | state_stop_reg;
    wire baud_count_increment = baud_count_enable & ~baud_count_max;

    assign baud_count_next = (baud_count_reg + 16'd1) & {16{baud_count_increment}} |
                             (16'd0 & {16{~baud_count_increment}});

    // Lógica del contador de bits
    wire bit_count_enable = state_data_reg & baud_count_max;
    wire bit_count_increment = bit_count_enable & ~bit_count_max;

    assign bit_count_next = (bit_count_reg + 1'b1) & {1{bit_count_increment}} |
                            (bit_count_reg & {1{~bit_count_increment}});

    // Lógica del registro de desplazamiento
    assign shift_reg_next = ( {rx, shift_reg_reg[1]} & {2{state_data_reg & baud_count_max}} ) |
                            ( shift_reg_reg & {2{~(state_data_reg & baud_count_max)}} );

    // Lógica de datos y validación
    assign data_next = (shift_reg_reg & {2{state_stop_reg & baud_count_max & rx}}) |
                       (data & {2{~(state_stop_reg & baud_count_max & rx)}});

    assign valid_next = (state_stop_reg & baud_count_max & rx) |
                        (1'b0 & ~(state_stop_reg & baud_count_max & rx));

    // Lógica secuencial sin 'if', 'case' ni '?'
    always @(posedge clk or negedge rst_n) begin
        // Actualización de estados
        state_idle_reg  <= (state_idle_next & rst_n) | (1'b1 & ~rst_n);
        state_start_reg <= (state_start_next & rst_n) | (1'b0 & ~rst_n);
        state_data_reg  <= (state_data_next & rst_n) | (1'b0 & ~rst_n);
        state_stop_reg  <= (state_stop_next & rst_n) | (1'b0 & ~rst_n);

        // Actualización de contadores y registros
        baud_count_reg <= (baud_count_next & {16{rst_n}}) | (16'd0 & {16{~rst_n}});
        bit_count_reg  <= (bit_count_next & rst_n) | (1'b0 & ~rst_n);
        shift_reg_reg  <= (shift_reg_next & {2{rst_n}}) | (2'd0 & {2{~rst_n}});

        // Actualización de salidas
        data  <= (data_next & {2{rst_n}}) | (2'd0 & {2{~rst_n}});
        valid <= (valid_next & rst_n) | (1'b0 & ~rst_n);
    end

endmodule