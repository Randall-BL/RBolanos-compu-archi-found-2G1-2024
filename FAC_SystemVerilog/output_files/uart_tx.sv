module uart_tx (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire send,
    output wire tx,
    output wire busy
);

    // Parámetros
    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 9600;
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;

    // Registros
    wire [15:0] baud_count_next;
    wire [3:0] bit_count_next;
    wire [9:0] shift_reg_next;
    wire transmitting_next;
    wire tx_next;
    wire busy_next;

    reg [15:0] baud_count_reg;
    reg [3:0] bit_count_reg;
    reg [9:0] shift_reg;
    reg transmitting_reg;
    reg tx_reg;
    reg busy_reg;

    // Señales internas
    wire baud_tick;
    wire bit_done;
    wire load_shift_reg;
    wire increment_baud_count;
    wire increment_bit_count;
    wire shift_data;
    wire set_transmitting;
    wire clear_transmitting;
    wire set_tx;
    wire clear_tx;

    // Lógica combinacional
    assign baud_tick = (baud_count_reg == BAUD_TICK - 1);
    assign bit_done = baud_tick & (bit_count_reg == 4'd9);
    
    // Lógica para baud_count_next
    assign load_shift_reg = send & ~transmitting_reg;
    assign increment_baud_count = transmitting_reg & ~baud_tick;
    assign baud_count_next = ({16{load_shift_reg | baud_tick}} & 16'd0) |
                             ({16{increment_baud_count}} & (baud_count_reg + 16'd1)) |
                             ({16{~(load_shift_reg | baud_tick | increment_baud_count)}} & baud_count_reg);

    // Lógica para bit_count_next
    assign increment_bit_count = baud_tick & transmitting_reg & ~bit_done;
    assign bit_count_next = ({4{bit_done}} & 4'd0) |
                            ({4{increment_bit_count}} & (bit_count_reg + 4'd1)) |
                            ({4{~(bit_done | increment_bit_count)}} & bit_count_reg);

    // Lógica para shift_reg_next
    assign shift_data = baud_tick & transmitting_reg;
    assign shift_reg_next = ({10{load_shift_reg}} & {1'b1, data_in, 1'b0}) |
                            ({10{shift_data}} & {1'b1, shift_reg[9:1]}) |
                            ({10{~(load_shift_reg | shift_data)}} & shift_reg);

    // Lógica para transmitting_next
    assign set_transmitting = send & ~transmitting_reg;
    assign clear_transmitting = bit_done;
    assign transmitting_next = (set_transmitting | transmitting_reg) & ~clear_transmitting;

    // Lógica para tx_next
    assign set_tx = ~transmitting_reg | (transmitting_reg & ~baud_tick);
    assign clear_tx = transmitting_reg & baud_tick & ~shift_reg[0];
    assign tx_next = set_tx & ~clear_tx;

    // Lógica para busy_next
    assign busy_next = transmitting_next;

    // Registros secuenciales
    always @(posedge clk or negedge rst_n) begin
        baud_count_reg <= baud_count_next & {16{rst_n}};
        bit_count_reg <= bit_count_next & {4{rst_n}};
        shift_reg <= shift_reg_next & {10{rst_n}};
        transmitting_reg <= transmitting_next & rst_n;
        tx_reg <= (tx_next & rst_n) | (~rst_n);
        busy_reg <= busy_next & rst_n;
    end

    // Asignaciones de salida
    assign tx = tx_reg;
    assign busy = busy_reg;

endmodule