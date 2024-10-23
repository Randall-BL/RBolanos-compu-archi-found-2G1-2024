

//Modulo del Primer Decodificador: Decoder inicial que recibe entradas de los dedos (1-4)

// Segunda version decoder
//1000 -> 01
//1100 -> 10
//1110 -> 11
//1111 -> 00

module FirtsDecoder_4to2bits(
    input A, B, C, D,
    output Y0, Y1
);

    // Conexiones (cables)
    wire notA, notB, notC, notD;
    wire and1, and2, and3, and4, and5, and6, or1;

    // Implementación de NOT para A, B, C y D
    not U1 (notA, A);
    not U2 (notB, B);
    not U3 (notC, C);
    not U4 (notD, D);

    // Implementación de Y0
    // Y0 = (A AND notB AND notC AND notD) OR (A AND B AND C AND notD)
    and U5 (and1, A, notB, notC, notD);  // A=1, B=0, C=0, D=0
    and U6 (and2, A, B, C, notD);        // A=1, B=1, C=1, D=0
    or  U7 (Y0, and1, and2);

    // Implementación de Y1
    // Y1 = (A AND B AND notC AND notD) OR (A AND B AND C AND notD)
    and U8 (and3, A, B, notC, notD);     // A=1, B=1, C=0, D=0
    and U9 (and4, A, B, C, notD);        // A=1, B=1, C=1, D=0
    or  U10 (Y1, and3, and4);

endmodule



// Primera version Decoder

//1000 -> 00
//1100 -> 01
//1110 -> 10
//1111 -> 11


//module FirtsDecoder_4to2bits (
//    input A, B, C, D,
//    output Y0, Y1
//);
//
//    // Conexiones (cables)
//    wire notC, notD;
//    wire and1, and2, or1;
//
//    // Implementación de NOT para C y D
//    not U1 (notC, C);
//    not U2 (notD, D);
//
//    // Implementación de Y0 = A AND B AND C //
//	 
//    and U3 (Y0, A, B, C);
//
//    // Implementación de Y1 = AB(-C-D+CD) //
//	 
//    // (notC AND notD)
//    and U4 (and1, notC, notD);
//    
//    // (C AND D)
//    and U5 (and2, C, D);
//    
//    // (notC AND notD) OR (C AND D)
//    or  U6 (or1, and1, and2);
//    
//    // AB AND ((notC AND notD) OR (C AND D))
//    and U7 (Y1, A, B, or1);
//
//endmodule
