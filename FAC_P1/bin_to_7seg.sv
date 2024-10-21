

// CONVERSION BCD A 7 SEGMENTOS
// SE DEBE CAMBIAR AL ESTRUCTURAL

module bin_to_7seg (
    input logic [3:0] bin,    // Entrada de 4 bits
    output logic [6:0] seg    // Salidas para los 7 segmentos (a-g)
);

    always_comb begin
        case (bin)
            4'b0000: seg = 7'b1000000; // 0
            4'b0001: seg = 7'b1111001; // 1
            4'b0010: seg = 7'b0100100; // 2
            4'b0011: seg = 7'b0110000; // 3
            4'b0100: seg = 7'b0011001; // 4
            4'b0101: seg = 7'b0010010; // 5
            4'b0110: seg = 7'b0000010; // 6
            4'b0111: seg = 7'b1111000; // 7
            4'b1000: seg = 7'b0000000; // 8
            4'b1001: seg = 7'b0010000; // 9
            4'b1010: seg = 7'b0001000; // A
            4'b1011: seg = 7'b0000011; // B
            4'b1100: seg = 7'b1000110; // C
            4'b1101: seg = 7'b0100001; // D
            4'b1110: seg = 7'b0000110; // E
            4'b1111: seg = 7'b0001110; // F
            default: seg = 7'b1111111; // Apagar todos los segmentos
        endcase
    end

endmodule

// FULL ESTRUCTURAL

//module bin_to_7seg (
//    input logic [3:0] bin,   // Entrada de 4 bits
//    output logic [6:0] seg   // Salidas para los 7 segmentos (a-g)
//);
//
//    // Segmento a
//    assign seg[6] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | 
//                    (~bin[3] & bin[2] & ~bin[1] & ~bin[0]) | 
//                    (bin[3] & ~bin[2] & bin[1] & bin[0]) | 
//                    (bin[3] & bin[2] & ~bin[1] & bin[0]);
//
//    // Segmento b
//    assign seg[5] = (~bin[3] & bin[2] & ~bin[1] & bin[0]) | 
//                    (bin[2] & bin[1] & ~bin[0]) | 
//                    (bin[3] & bin[1] & bin[0]) | 
//                    (bin[3] & bin[2] & ~bin[0]);
//
//    // Segmento c
//    assign seg[4] = (~bin[3] & ~bin[2] & bin[1] & ~bin[0]) | 
//                    (bin[3] & bin[2] & ~bin[0]) | 
//                    (bin[3] & bin[2] & bin[1]);
//
//    // Segmento d
//    assign seg[3] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | 
//                    (~bin[3] & bin[2] & ~bin[1] & ~bin[0]) | 
//                    (bin[2] & bin[1] & bin[0]) | 
//                    (bin[3] & ~bin[2] & bin[1] & ~bin[0]);
//
//    // Segmento e
//    assign seg[2] = (~bin[3] & bin[0]) | 
//                    (~bin[3] & bin[2] & ~bin[1]) | 
//                    (~bin[2] & ~bin[1] & bin[0]);
//
//    // Segmento f
//    assign seg[1] = (~bin[3] & ~bin[2] & bin[0]) | 
//                    (~bin[3] & ~bin[2] & bin[1]) | 
//                    (~bin[3] & bin[1] & bin[0]) | 
//                    (bin[3] & bin[2] & ~bin[1] & bin[0]);
//
//    // Segmento g
//    assign seg[0] = (~bin[3] & ~bin[2] & ~bin[1]) | 
//                    (bin[3] & bin[2] & ~bin[1] & ~bin[0]) | 
//                    (~bin[3] & bin[2] & bin[1] & bin[0]);
//
//endmodule
