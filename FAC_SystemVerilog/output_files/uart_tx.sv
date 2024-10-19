module uart_tx (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire [7:0] data_in, // Dato de 8 bits a enviar
    input wire send,         // Señal para iniciar la transmisión
    output wire tx,          // Señal TX UART
    output wire busy         // Señal que indica si está transmitiendo
);
    // Parámetros de UART
    parameter CLK_FREQ = 50000000;  // Frecuencia del reloj del sistema (50 MHz)
    parameter BAUD_RATE = 9600;     // Baud rate de UART (9600)
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;  // Tiempo de un tick de UART

    // Registros internos
    reg [15:0] baud_count_reg;
    reg [3:0] bit_count_reg;
    reg [9:0] shift_reg;
    reg transmitting_reg;
    reg tx_reg;
    reg busy_reg;

    // Señales de siguiente estado
    wire [15:0] baud_count_next;
    wire [3:0] bit_count_next;
    wire [9:0] shift_reg_next;
    wire transmitting_next;
    wire tx_next;
    wire busy_next;

    // Lógica combinacional para calcular los siguientes estados
    wire baud_tick = (baud_count_reg == BAUD_TICK - 1);
    wire bit_done = baud_tick & (bit_count_reg == 4'd9);

    assign baud_count_next = (baud_tick | (send & ~transmitting_reg)) ? 16'd0 :
                             (transmitting_reg) ? baud_count_reg + 16'd1 : baud_count_reg;

    assign bit_count_next = (bit_done) ? 4'd0 :
                            (baud_tick & transmitting_reg) ? bit_count_reg + 4'd1 : bit_count_reg;

    assign shift_reg_next = (send & ~transmitting_reg) ? {1'b1, data_in, 1'b0} :
                            (baud_tick & transmitting_reg) ? {1'b1, shift_reg[9:1]} : shift_reg;

    assign transmitting_next = (send & ~transmitting_reg) ? 1'b1 :
                               (bit_done) ? 1'b0 : transmitting_reg;

    assign tx_next = (transmitting_reg & baud_tick) ? shift_reg[0] :
                     (~transmitting_reg) ? 1'b1 : tx_reg;

    assign busy_next = transmitting_next;

    // Lógica secuencial sin usar if-else
    always @(posedge clk or negedge rst_n) begin
        baud_count_reg <= (baud_count_next & {16{rst_n}}) | (16'd0 & {16{~rst_n}});
        bit_count_reg <= (bit_count_next & {4{rst_n}}) | (4'd0 & {4{~rst_n}});
        shift_reg <= (shift_reg_next & {10{rst_n}}) | (10'd0 & {10{~rst_n}});
        transmitting_reg <= (transmitting_next & rst_n) | (1'b0 & ~rst_n);
        tx_reg <= (tx_next & rst_n) | (1'b1 & ~rst_n);
        busy_reg <= (busy_next & rst_n) | (1'b0 & ~rst_n);
    end

    // Asignaciones de salida
    assign tx = tx_reg;
    assign busy = busy_reg;

endmodule