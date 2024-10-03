module tb_Decoder_4To2bits;

    // Declaración de señales
    reg A, B, C, D;
    wire Y0, Y1;

    // Instancia del módulo bajo prueba (DUT)
    Decoder_4To2bits dut (
        .A(A), 
        .B(B), 
        .C(C), 
        .D(D), 
        .Y0(Y0), 
        .Y1(Y1)
    );

    // Proceso de prueba
    initial begin
        // Monitorear cambios en las señales y mostrar los resultados
        $monitor("A = %b, B = %b, C = %b, D = %b -> Y0 = %b, Y1 = %b", A, B, C, D, Y0, Y1);
        
        // Aplicar los valores de la tabla uno por uno

        // Fila 1: A = 0, B = 0, C = 0, D = 0
        A = 0; B = 0; C = 0; D = 0;
        #10; // Esperar 10 unidades de tiempo

        // Fila 2: A = 0, B = 0, C = 0, D = 1
        A = 0; B = 0; C = 0; D = 1;
        #10;

        // Fila 3: A = 0, B = 0, C = 1, D = 0
        A = 0; B = 0; C = 1; D = 0;
        #10;

        // Fila 4: A = 0, B = 0, C = 1, D = 1
        A = 0; B = 0; C = 1; D = 1;
        #10;

        // Fila 5: A = 0, B = 1, C = 0, D = 0
        A = 0; B = 1; C = 0; D = 0;
        #10;

        // Fila 6: A = 0, B = 1, C = 0, D = 1
        A = 0; B = 1; C = 0; D = 1;
        #10;

        // Fila 7: A = 0, B = 1, C = 1, D = 0
        A = 0; B = 1; C = 1; D = 0;
        #10;

        // Fila 8: A = 0, B = 1, C = 1, D = 1
        A = 0; B = 1; C = 1; D = 1;
        #10;

        // Fila 9: A = 1, B = 0, C = 0, D = 0
        A = 1; B = 0; C = 0; D = 0;
        #10;

        // Fila 10: A = 1, B = 0, C = 0, D = 1
        A = 1; B = 0; C = 0; D = 1;
        #10;

        // Fila 11: A = 1, B = 0, C = 1, D = 0
        A = 1; B = 0; C = 1; D = 0;
        #10;

        // Fila 12: A = 1, B = 0, C = 1, D = 1
        A = 1; B = 0; C = 1; D = 1;
        #10;

        // Fila 13: A = 1, B = 1, C = 0, D = 0
        A = 1; B = 1; C = 0; D = 0;
        #10;

        // Fila 14: A = 1, B = 1, C = 0, D = 1
        A = 1; B = 1; C = 0; D = 1;
        #10;

        // Fila 15: A = 1, B = 1, C = 1, D = 0
        A = 1; B = 1; C = 1; D = 0;
        #10;

        // Fila 16: A = 1, B = 1, C = 1, D = 1
        A = 1; B = 1; C = 1; D = 1;
        #10;

        // Terminar la simulación
        $finish;
    end

endmodule
