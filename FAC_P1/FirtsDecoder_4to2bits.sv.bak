

//Modulo del Primer Decodificador: Decoder inicial que recibe entradas de los dedos (1-4)

module FirtsDecoder_4to2bits (
    input A, B, C, D,
    output Y0, Y1
);

    // Conexiones (cables)
    wire notC, notD;
    wire and1, and2, or1;

    // Implementación de NOT para C y D
    not U1 (notC, C);
    not U2 (notD, D);

    // Implementación de Y0 = A AND B AND C //
	 
    and U3 (Y0, A, B, C);

    // Implementación de Y1 = AB(-C-D+CD) //
	 
    // (notC AND notD)
    and U4 (and1, notC, notD);
    
    // (C AND D)
    and U5 (and2, C, D);
    
    // (notC AND notD) OR (C AND D)
    or  U6 (or1, and1, and2);
    
    // AB AND ((notC AND notD) OR (C AND D))
    and U7 (Y1, A, B, or1);

endmodule
