
//Modulo del Segundo Decodificador: Recibe como dos entradas las salidas del primer decoder y otras dos adicionales
// Circular 3 bits

module Decoder_4To2bits (
    input A, B, C, D,
    output Y0, Y1
);

    // Cables de las conexiones intermedias de las compuertas
    wire notA, notB, notC, notD;
    wire andY0_1, andY0_2, andY0_3, andY0_4, andY0_5, andY0_6;  // Señales intermedias para Y0
    wire andY1_1, andY1_2;  												 // Señales intermedias para Y1
    // Negaciones de A, B, C y D
    not U1 (notA, A);
    not U2 (notB, B);
    not U3 (notC, C);
    not U4 (notD, D);

    // Implementación de Y0 = (-A*B*-C) + (-A*-C*D) + ABC + ACD + (-A*-B*C*-D) + (A*-B*-C*-D) :	 
    // (-A*B*-C)
    and U5 (andY0_1, notA, B, notC);
    // (-A*-C*D)
    and U6 (andY0_2, notA, notC, D);
    // (A*B*C)
    and U7 (andY0_3, A, B, C);
    // (A*C*D)
    and U8 (andY0_4, A, C, D);
    // (-A*-B*C*-D)
    and U9 (andY0_5, notA, notB, C, notD);
    // (A*-B*-C*-D)
    and U10 (andY0_6, A, notB, notC, notD);
    // OR para juntar todos los términos de Y0
    or U11 (Y0, andY0_1, andY0_2, andY0_3, andY0_4, andY0_5, andY0_6);

    // Implementación de Y1 = (B*D) + (-B*-D) : 
    // (B*D)
    and U12 (andY1_1, B, D);
    // (-B*-D)
    and U13 (andY1_2, notB, notD);
    // OR para Y1
    or U14 (Y1, andY1_1, andY1_2);

endmodule
