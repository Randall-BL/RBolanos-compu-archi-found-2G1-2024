

// CONVERSION BCD A 7 SEGMENTOS
// FULL ESTRUCTURAL - FUNCIONAL


module bin_to_7seg (
    input logic [3:0] bin,    // Entrada de 4 bits
    output logic [6:0] seg    // Salidas para los 7 segmentos (a-g)
);

    // Definición de las conexiones para cada segmento
    logic not_bin3, not_bin2, not_bin1, not_bin0;  // Inversas de las entradas
    logic a, b, c, d, e, f, g;                     // Segmentos individuales

    // Generación de las señales invertidas
    assign not_bin3 = ~bin[3];
    assign not_bin2 = ~bin[2];
    assign not_bin1 = ~bin[1];
    assign not_bin0 = ~bin[0];

    // Definición de las salidas para los segmentos
    // Segmento a
    assign seg[0] = (not_bin3 & not_bin2 & not_bin1 & bin[0]) |  // 0
                    (not_bin3 & bin[2] & not_bin1 & not_bin0) |  // 2
                    (bin[3] & not_bin2 & bin[1] & bin[0]) |     // 3
                    (bin[3] & bin[2] & not_bin1 & bin[0]);      // 6

    // Segmento b
    assign seg[1] = (not_bin3 & bin[2] & not_bin1 & bin[0]) |     // 1
                    (bin[2] & bin[1] & not_bin0) |               // 3
                    (bin[3] & bin[1] & bin[0]) |                 // 5
                    (bin[3] & bin[2] & not_bin0);                // 6

    // Segmento c
    assign seg[2] = (not_bin3 & not_bin2 & bin[1] & not_bin0) |   // 0
                    (bin[3] & bin[2] & not_bin0) |               // 6
                    (bin[3] & bin[2] & bin[1]);                  // 7

    // Segmento d
    assign seg[3] = (not_bin3 & not_bin2 & not_bin1 & bin[0]) |   // 0
                    (not_bin3 & bin[2] & not_bin1 & not_bin0) |  // 2
                    (bin[2] & bin[1] & bin[0]) |                 // 3
                    (bin[3] & not_bin2 & bin[1] & not_bin0);     // 5

    // Segmento e
    assign seg[4] = (not_bin3 & bin[0]) |                            // 1
                    (not_bin3 & bin[2] & not_bin1) |               // 4
                    (not_bin2 & not_bin1 & bin[0]);                // 6

    // Segmento f
    assign seg[5] = (not_bin3 & not_bin2 & bin[0]) |                 // 1
                    (not_bin3 & not_bin2 & bin[1]) |               // 4
                    (not_bin3 & bin[1] & bin[0]) |                 // 5
                    (bin[3] & bin[2] & not_bin1 & bin[0]);         // 6

    // Segmento g
    assign seg[6] = (not_bin3 & not_bin2 & not_bin1) |               // 0
                    (bin[3] & bin[2] & not_bin1 & not_bin0) |      // 3
                    (not_bin3 & bin[2] & bin[1] & bin[0]);        // 7

endmodule




// BCD TO 7 SEG - Version para pruebas
//module bin_to_7seg (
//    input logic [3:0] bin,    // Entrada de 4 bits
//    output logic [6:0] seg    // Salidas para los 7 segmentos (a-g)
//);
//
//    always_comb begin
//        case (bin)
//            4'b0000: seg = 7'b1000000; // 0
//            4'b0001: seg = 7'b1111001; // 1
//            4'b0010: seg = 7'b0100100; // 2
//            4'b0011: seg = 7'b0110000; // 3
//            4'b0100: seg = 7'b0011001; // 4
//            4'b0101: seg = 7'b0010010; // 5
//            4'b0110: seg = 7'b0000010; // 6
//            4'b0111: seg = 7'b1111000; // 7
//            4'b1000: seg = 7'b0000000; // 8
//            4'b1001: seg = 7'b0010000; // 9
//            4'b1010: seg = 7'b0001000; // A
//            4'b1011: seg = 7'b0000011; // B
//            4'b1100: seg = 7'b1000110; // C
//            4'b1101: seg = 7'b0100001; // D
//            4'b1110: seg = 7'b0000110; // E
//            4'b1111: seg = 7'b0001110; // F
//            default: seg = 7'b1111111; // Apagar todos los segmentos
//        endcase
//    end
//
//endmodule

