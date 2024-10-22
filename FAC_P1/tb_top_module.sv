

// TESTBENCH DEL TOP_MODULE
// FUNCIONAMIENTO DE LAS BANDERAS ( Z, C, V, S )
// VELOCIDADES PWM ( 25%, 50%, 75%, 100% )


//module tb_top_module;
//
//    // Señales de entrada
//    logic clk;
//    logic rst;
//    logic A, B, C, D;    // Entradas del decodificador (dedos)
//    logic [1:0] alu_b;
//    logic [1:0] alu_op;
//
//    // Señales de salida
//    logic motor_pwm;
//    logic [6:0] seg1;
//
//    // Instancia del top module
//    top_module dut (
//        .clk(clk),
//        .rst(rst),
//        .A(A),
//        .B(B),
//        .C(C),
//        .D(D),
//        .rx(rx),
//        .alu_op(alu_op),
//        .motor_pwm(motor_pwm),
//        .seg1(seg1)
//    );
//
//    // Generación del reloj
//    always #5 clk = ~clk; // Reloj con periodo de 10 unidades de tiempo
//
//    // Testbench
//    initial begin
//        // Inicialización de señales
//        clk = 0;
//        rst = 0;
//        alu_b = 2'b00;
//        alu_op = 2'b00;
//
//        // Reset del sistema
//        #10 rst = 1;
//        #10 rst = 0;
//
//        // Combinaciones de prueba para el decodificador - ALU - PWM
//		  
//        // Entrada 1000
//        A = 1;
//        B = 0;
//        C = 0;
//        D = 0;
//        alu_b = 2'b01; 
//        alu_op = 2'b00; // Suma
//        #20;
//        $display("Dec: 1000, Decoder Result: %b, ALU IN2: %b, ALU Operation: SUM, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//		//$display("ALU Operation: SUM, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a + alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//
//        // Entrada 1100
//        A = 1;
//        B = 1;
//        C = 0;
//        D = 0;
//        alu_b = 2'b11;
//        alu_op = 2'b11; // OR
//        #20;
//		  $display("Dec: 1100, Decoder Result: %b, ALU IN2: %b, ALU Operation: OR, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//		
//
//        // Entrada 1110
//        A = 1;
//        B = 1;
//        C = 1;
//        D = 0;
//        alu_b = 2'b10;
//        alu_op = 2'b01; // Resta
//        #20;
//		  $display("Dec: 1110, Decoder Result: %b, ALU IN2: %b, ALU Operation: SUB, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//		
//    
//        // Entrada 1111
//        A = 1;
//        B = 1;
//        C = 1;
//        D = 1;
//        alu_b = 2'b10;
//        alu_op = 2'b10; // AND
//        #20;
//		  $display("Dec: 1111, Decoder Result: %b, ALU IN2: %b, ALU Operation: AND, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//		
//		  //Casos para verificar las banderas de la ALU:
//
//        // Bandera Zero: Cuando a = 0, b = 0 en la operación AND (debe dar Z = 1)
//		  A = 1;
//        B = 1;
//        C = 1;
//        D = 1;
//        alu_b = 2'b00;
//        alu_op = 2'b10; // AND
//        #20;
//        $display("Flag Test - Z, ALU result: %b, Z: %b", dut.alu_result, dut.alu_inst.Z);
//
//        // Bandera Carry: Cuando a = 3, b = 3 en la operación SUM (debe dar C = 1)
//        A = 1;
//        B = 1;
//        C = 1;
//        D = 0; 
//        alu_b = 2'b11; 
//        alu_op = 2'b00; // Suma
//        #20;
//        $display("Flag Test - C, ALU result: %b, C: %b", dut.alu_result, dut.alu_inst.C);
//
//        // Bandera Overflow: Cuando a = 2, b = 3 en la operación SUM (debe dar V = 1)
//        A = 1;
//        B = 1;
//        C = 0;
//        D = 0; 
//        alu_b = 2'b11; 
//        alu_op = 2'b00; // Suma
//        #20;
//        $display("Flag Test - V, ALU result: %b, V: %b", dut.alu_result, dut.alu_inst.V);
//
//        // Bandera Signo: Cuando a = 1, b = 3 en la operación SUBTRACT (debe dar S = 1)
//        A = 1;
//        B = 0;
//        C = 0;
//        D = 0; 
//        alu_b = 2'b11; 
//        alu_op = 2'b01; // Resta
//        #20;
//        $display("Flag Test - S, ALU result: %b, S: %b", dut.alu_result, dut.alu_inst.S);
//
//        // Finalizar simulación
//        #100 $finish;
//    end
//
//endmodule


module tb_top_module;

    // Señales de entrada
    logic clk;
    logic rst;
    logic A, B, C, D;    // Entradas del decodificador (dedos)
    logic rx;            // Señal de entrada del UART para alu_b
    logic [1:0] alu_op;

    // Señales de salida
    logic motor_pwm;
    logic [6:0] seg1;
    logic [3:0] leds;

    // Instancia del top module
    top_module dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .rx(rx),
        .alu_op(alu_op),
        .motor_pwm(motor_pwm),
        .seg1(seg1),
        .leds(leds)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Reloj con periodo de 10 unidades de tiempo

    // Simulación de la línea UART RX (envía 2 bits de datos)
    task uart_send_2bits(input [1:0] two_bits);
        integer i;
        begin
            // Enviar bit de start (0)
            rx = 1'b0;
            #10417;  // Ajuste del tiempo de bit a 9600 baudios (para simulación)

            // Enviar los 2 bits de datos (LSB primero)
            for (i = 0; i < 2; i = i + 1) begin
                rx = two_bits[i];
                #10417;  // Tiempo entre bits
            end

            // Enviar bit de stop (1)
            rx = 1'b1;
            #10417;
        end
    endtask

    // Testbench
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        rx = 1;   // Línea UART inactiva (idle es alto)
        alu_op = 2'b00;

        // Reset del sistema
        #10 rst = 1;
        #10 rst = 0;

        // Combinaciones de prueba para el decodificador - ALU - PWM

        // Entrada 1000, enviamos por UART el valor 01 a la ALU
        A = 1;
        B = 0;
        C = 0;
        D = 0;
        alu_op = 2'b00; // Suma
        #10 uart_send_2bits(2'b01); // Enviar 01 al UART
        #100;
        $display("Dec: 1000, ALU Operation: SUM, ALU IN2: %b, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Entrada 1100, enviamos por UART el valor 11 a la ALU
        A = 1;
        B = 1;
        C = 0;
        D = 0;
        alu_op = 2'b11; // OR
        #10 uart_send_2bits(2'b11); // Enviar 11 al UART
        #100;
        $display("Dec: 1100, ALU Operation: OR, ALU IN2: %b, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Entrada 1110, enviamos por UART el valor 10 a la ALU
        A = 1;
        B = 1;
        C = 1;
        D = 0;
        alu_op = 2'b01; // Resta
        #10 uart_send_2bits(2'b10); // Enviar 10 al UART
        #100;
        $display("Dec: 1110, ALU Operation: SUB, ALU IN2: %b, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Entrada 1111, enviamos por UART el valor 10 a la ALU
        A = 1;
        B = 1;
        C = 1;
        D = 1;
        alu_op = 2'b10; // AND
        #10 uart_send_2bits(2'b10); // Enviar 10 al UART
        #100;
        $display("Dec: 1111, ALU Operation: AND, ALU IN2: %b, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
        
		// Verificaciones adicionales de las banderas de la ALU

        // Zero flag: Cuando a = 0 y b = 0 en la operación AND (Z debe ser 1)
        A = 0;
        B = 0;
        C = 0;
        D = 0;
        alu_op = 2'b10; // AND
        #10 uart_send_2bits(2'b00); // Enviar 00 al UART
        #100;
        $display("Flag Test - Z, ALU result: %b, Z: %b", dut.alu_result, dut.alu_inst.Z);

        // Carry flag: Suma con a = 3 y b = 3 (Carry debe ser 1)
        A = 1;
        B = 1;
        C = 1;
        D = 0; 
        alu_op = 2'b00; // Suma
        #10 uart_send_2bits(2'b11); // Enviar 11 al UART
        #100;
        $display("Flag Test - C, ALU result: %b, C: %b", dut.alu_result, dut.alu_inst.C);

        // Overflow flag: Suma con a = 2 y b = 3 (Overflow debe ser 1)
        A = 1;
        B = 1;
        C = 0;
        D = 0; 
        alu_op = 2'b00; // Suma
        #10 uart_send_2bits(2'b11); // Enviar 11 al UART
        #100;
        $display("Flag Test - V, ALU result: %b, V: %b", dut.alu_result, dut.alu_inst.V);

        // Sign flag: Resta con a = 1 y b = 3 (Signo debe ser 1)
        A = 1;
        B = 0;
        C = 0;
        D = 0; 
        alu_op = 2'b01; // Resta
        #10 uart_send_2bits(2'b11); // Enviar 11 al UART
        #100;
        $display("Flag Test - S, ALU result: %b, S: %b", dut.alu_result, dut.alu_inst.S);

        // Finalizar simulación
        #100 $finish;
    end

endmodule


//module tb_top_module;
//
//    // Señales de entrada
//    logic clk;
//    logic rst;
//    logic A, B, C, D;    // Entradas del decodificador (dedos)
//    logic rx;            // Señal de entrada del UART
//    logic [1:0] alu_op;
//
//    // Señales de salida
//    logic motor_pwm;
//    logic [6:0] seg1;
//    logic [3:0] leds;
//
//    // Instancia del top module
//    top_module dut (
//        .clk(clk),
//        .rst(rst),
//        .A(A),
//        .B(B),
//        .C(C),
//        .D(D),
//        .rx(rx),
//        .alu_op(alu_op),
//        .motor_pwm(motor_pwm),
//        .seg1(seg1),
//        .leds(leds)
//    );
//
//    // Generación del reloj
//    always #5 clk = ~clk; // Reloj con periodo de 10 unidades de tiempo
//
//    // Simulación de la línea UART RX (envía 8 bits de datos)
//    task uart_send_byte(input [1:0] byte_data);
//        integer i;
//        begin
//            // Enviar bit de start (0)
//            rx = 1'b0;
//            #8680;  // Ajuste del tiempo de bit a 9600 baudios (para simulación)
//
//            // Enviar los 8 bits de datos (LSB primero)
//            for (i = 0; i < 2; i = i + 1) begin
//                rx = byte_data[i];
//                #8680;  // Tiempo entre bits
//            end
//
//            // Enviar bit de stop (1)
//            rx = 1'b1;
//            #8680;
//        end
//    endtask
//
//    // Testbench
//    initial begin
//        // Inicialización de señales
//        clk = 0;
//        rst = 0;
//        rx = 1;   // Línea UART inactiva (idle es alto)
//        alu_op = 2'b00;
//
//        // Reset del sistema
//        #10 rst = 1;
//        #10 rst = 0;
//
//        // Combinaciones de prueba para el decodificador - ALU - PWM
//		  
//        // Entrada 1000, enviamos por UART el valor 01 a la ALU
//        A = 1;
//        B = 0;
//        C = 0;
//        D = 0;
//        alu_op = 2'b00; // Suma
//        #10 uart_send_byte(2'b01); // Enviar 01 al UART
//        #100;
//		  $display("Dec: 1000, Decoder Result: %b, ALU IN2: %b, ALU Operation: SUM, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//        // Entrada 1100, enviamos por UART el valor 11 a la ALU
//        A = 1;
//        B = 1;
//        C = 0;
//        D = 0;
//        alu_op = 2'b11; // OR
//        #10 uart_send_byte(2'b11); // Enviar 11 al UART
//        #100;
//		  $display("Dec: 1100, Decoder Result: %b, ALU IN2: %b, ALU Operation: OR, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
// 
//        // Entrada 1110, enviamos por UART el valor 10 a la ALU
//        A = 1;
//        B = 1;
//        C = 1;
//        D = 0;
//        alu_op = 2'b01; // Resta
//        #10 uart_send_byte(2'b10); // Enviar 10 al UART
//        #100;
//		  $display("Dec: 1110, Decoder Result: %b, ALU IN2: %b, ALU Operation: SUB, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//        // Entrada 1111, enviamos por UART el valor 10 a la ALU
//        A = 1;
//        B = 1;
//        C = 1;
//        D = 1;
//        alu_op = 2'b10; // AND
//        #10 uart_send_byte(2'b10); // Enviar 10 al UART
//        #100;
//		  $display("Dec: 1111, Decoder Result: %b, ALU IN2: %b, ALU Operation: SUM, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", dut.dec_result, dut.alu_b, dut.alu_result, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//        
//		  // Verificaciones adicionales de las banderas de la ALU
//
//        // Zero flag: Cuando a = 0 y b = 0 en la operación AND (Z debe ser 1)
//        A = 0;
//        B = 0;
//        C = 0;
//        D = 0;
//        alu_op = 2'b10; // AND
//        #10 uart_send_byte(2'b00); // Enviar 00 al UART
//        #100;
//        $display("Flag Test - Z, ALU result: %b, Z: %b", dut.alu_result, dut.alu_inst.Z);
//
//        // Carry flag: Suma con a = 3 y b = 3 (Carry debe ser 1)
//        A = 1;
//        B = 1;
//        C = 1;
//        D = 0; 
//        alu_op = 2'b00; // Suma
//        #10 uart_send_byte(2'b11); // Enviar 11 al UART
//        #100;
//        $display("Flag Test - C, ALU result: %b, C: %b", dut.alu_result, dut.alu_inst.C);
//
//        // Overflow flag: Suma con a = 2 y b = 3 (Overflow debe ser 1)
//        A = 1;
//        B = 1;
//        C = 0;
//        D = 0; 
//        alu_op = 2'b00; // Suma
//        #10 uart_send_byte(2'b11); // Enviar 11 al UART
//        #100;
//        $display("Flag Test - V, ALU result: %b, V: %b", dut.alu_result, dut.alu_inst.V);
//
//        // Sign flag: Resta con a = 1 y b = 3 (Signo debe ser 1)
//        A = 1;
//        B = 0;
//        C = 0;
//        D = 0; 
//        alu_op = 2'b01; // Resta
//        #10 uart_send_byte(2'b11); // Enviar 11 al UART
//        #100;
//        $display("Flag Test - S, ALU result: %b, S: %b", dut.alu_result, dut.alu_inst.S);
//
//        // Finalizar simulación
//        #100 $finish;
//    end
//
//endmodule
