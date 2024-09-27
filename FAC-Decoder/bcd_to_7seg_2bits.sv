module bcd_to_7seg_2bits (
    input logic [1:0] bcd,    // Entrada de 2 bits (Y0,Y1)
    output logic [6:0] seg    // Salidas para los 7 segmentos (a-g)
);

    always_comb begin
        case (bcd)
            2'b00: seg = 7'b1000000; // 0
            2'b01: seg = 7'b1111001; // 1
            2'b10: seg = 7'b0100100; // 2
            2'b11: seg = 7'b0110000; // 3
            default: seg = 7'b1111111; // Apagar todos los segmentos
        endcase
    end

endmodule
