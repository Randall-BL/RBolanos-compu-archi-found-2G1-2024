module Decoder_4To2bits (
    input A, B, C, D,
    output Y0, Y1,
    output [6:0] seg   // Salida para el display de 7 segmentos
);

    // Cables intermedios para las conexiones intermedias de las compuertas
    wire notA, notB, notC, notD;
    wire andY0_1, andY0_2, andY0_3, andY0_4, andY0_5, andY0_6;  // Señales intermedias para Y0
    wire andY1_1, andY1_2;  // Señales intermedias para Y1

    // Negaciones de A, B, C y D
    not U1 (notA, A);
    not U2 (notB, B);
    not U3 (notC, C);
    not U4 (notD, D);

    // Implementación de Y0 = (-A*B*-C) + (-A*-C*D) + ABC + ACD + (-A*-B*C*-D) + (A*-B*-C*-D)
	 
    // Término 1: (-A*B*-C)
    and U5 (andY0_1, notA, B, notC);
    // Término 2: (-A*-C*D)
    and U6 (andY0_2, notA, notC, D);
    // Término 3: (A*B*C)
    and U7 (andY0_3, A, B, C);
    // Término 4: (A*C*D)
    and U8 (andY0_4, A, C, D);
    // Término 5: (-A*-B*C*-D)
    and U9 (andY0_5, notA, notB, C, notD);
    // Término 6: (A*-B*-C*-D)
    and U10 (andY0_6, A, notB, notC, notD);

    // OR para juntar todos los términos de Y0
    or U11 (Y0, andY0_1, andY0_2, andY0_3, andY0_4, andY0_5, andY0_6);

    // Implementación de Y1 = (B*D) + (-B*-D)
	 
    // Término 1: (B*D)
    and U12 (andY1_1, B, D);
    // Término 2: (-B*-D)
    and U13 (andY1_2, notB, notD);

    // OR para Y1
    or U14 (Y1, andY1_1, andY1_2);

    //// Instancia del módulo bcd_to_7seg_2bits
    //bcd_to_7seg_2bits U15 (
    //    .bcd({Y0, Y1}),  // Se conectan Y0 y Y1 como entrada al módulo de 7 segmentos
    //    .seg(seg)        // Salida para los 7 segmentos
    //);

endmodule
