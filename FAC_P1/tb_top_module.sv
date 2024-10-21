

// TESTBENCH DEL TOP_MODULE
// FUNCIONAMIENTO DE LAS BANDERAS ( Z, C, V, S )
// VELOCIDADES PWM ( 25%, 50%, 75%, 100% )

module tb_top_module;

    // Señales de entrada
    logic clk;
    logic rst;
    logic [1:0] alu_a;
    logic [1:0] alu_b;
    logic [1:0] alu_op;
    
    // Señales de salida
    logic motor_pwm;

    // Instancia del top module
    top_module dut (
        .clk(clk),
        .rst(rst),
        .alu_a(alu_a),
        .alu_b(alu_b),
        .alu_op(alu_op),
        .motor_pwm(motor_pwm)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Reloj con periodo de 10 unidades de tiempo

    // Testbench
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        alu_a = 2'b00;
        alu_b = 2'b00;
        alu_op = 2'b00;

        // Reset del sistema
        #10 rst = 1;
        #10 rst = 0;

        // Caso de prueba 1: Suma (00) con a = 2, b = 1
        alu_a = 2'b10; 
        alu_b = 2'b01; 
        alu_op = 2'b00; // Suma
        #20;
        $display("ALU Operation: SUM, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a + alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Caso de prueba 2: Resta (01) con a = 3, b = 1
        alu_a = 2'b11; 
        alu_b = 2'b01; 
        alu_op = 2'b01; // Resta
        #20;
        $display("ALU Operation: SUBTRACT, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a - alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Caso de prueba 3: AND (10) con a = 3, b = 2
        alu_a = 2'b01; 
        alu_b = 2'b10; 
        alu_op = 2'b10; // AND
        #20;
        $display("ALU Operation: AND, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a & alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Caso de prueba 4: OR (11) con a = 1, b = 0
        alu_a = 2'b01; 
        alu_b = 2'b00; 
        alu_op = 2'b11; // OR
        #20;
        $display("ALU Operation: OR, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a | alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);

        // Casos para verificar las banderas:

        // Bandera Zero: Cuando a = 0, b = 0 en la operación AND (debe dar Z = 1)
        alu_a = 2'b00; 
        alu_b = 2'b00;
        alu_op = 2'b10; // AND
        #20;
        $display("Flag Test - Z, ALU result: %b, Z: %b", alu_a & alu_b, dut.alu_inst.Z);

        // Bandera Carry: Cuando a = 3, b = 3 en la operación SUM (debe dar C = 1)
        alu_a = 2'b11; 
        alu_b = 2'b11; 
        alu_op = 2'b00; // Suma
        #20;
        $display("Flag Test - C, ALU result: %b, C: %b", alu_a + alu_b, dut.alu_inst.C);

        // Bandera Overflow: Cuando a = 2, b = 3 en la operación SUM (debe dar V = 1)
        alu_a = 2'b10; 
        alu_b = 2'b11; 
        alu_op = 2'b00; // Suma
        #20;
        $display("Flag Test - V, ALU result: %b, V: %b", alu_a + alu_b, dut.alu_inst.V);

        // Bandera Signo: Cuando a = 1, b = 3 en la operación SUBTRACT (debe dar S = 1)
        alu_a = 2'b01; 
        alu_b = 2'b11; 
        alu_op = 2'b01; // Resta
        #20;
        $display("Flag Test - S, ALU result: %b, S: %b", alu_a - alu_b, dut.alu_inst.S);

        // Finalizar simulación
        #100 $finish;
    end

endmodule



// PRUEBAS APARTE (NO TOMAR EN CUENTA)

//initial begin
//    // Inicialización de señales
//    clk = 0;
//    rst = 0;
//    alu_a = 2'b00;
//    alu_b = 2'b00;
//    alu_op = 2'b00;
//
//    // Reset del sistema
//    #10 rst = 1;
//    #10 rst = 0;
//
//    // Caso de prueba 1: Suma (00) con a = 2, b = 1
//    alu_a = 2'b10; 
//    alu_b = 2'b01; 
//    alu_op = 2'b00; // Suma
//    #20;
//    $display("ALU Operation: SUM, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a + alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//    // Caso de prueba 2: Resta (01) con a = 3, b = 1
//    alu_a = 2'b11; 
//    alu_b = 2'b01; 
//    alu_op = 2'b01; // Resta
//    #20;
//    $display("ALU Operation: SUBTRACT, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a - alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//    // Caso de prueba 3: AND (10) con a = 3, b = 2
//    alu_a = 2'b11; 
//    alu_b = 2'b10; 
//    alu_op = 2'b10; // AND
//    #20;
//    $display("ALU Operation: AND, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a & alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//    // Caso de prueba 4: OR (11) con a = 1, b = 0
//    alu_a = 2'b01; 
//    alu_b = 2'b00; 
//    alu_op = 2'b11; // OR
//    #20;
//    $display("ALU Operation: OR, ALU result: %b, Motor speed: %b, Flags - Z: %b, C: %b, V: %b, S: %b", alu_a | alu_b, dut.pwm_inst.motor_speed, dut.alu_inst.Z, dut.alu_inst.C, dut.alu_inst.V, dut.alu_inst.S);
//
//    // Casos para verificar las banderas:
//
//    // Bandera Zero: Cuando a = 0, b = 0 en la operación AND (debe dar Z = 1)
//    alu_a = 2'b00; 
//    alu_b = 2'b00;
//    alu_op = 2'b10; // AND
//    #20;
//    $display("Flag Test - Z, ALU result: %b, Z: %b", alu_a & alu_b, dut.alu_inst.Z);
//
//    // Bandera Carry: Cuando a = 3, b = 3 en la operación SUM (debe dar C = 1)
//    alu_a = 2'b11; 
//    alu_b = 2'b11; 
//    alu_op = 2'b00; // Suma
//    #20;
//    $display("Flag Test - C, ALU result: %b, C: %b", alu_a + alu_b, dut.alu_inst.C);
//
//    // Bandera Overflow: Cuando a = 2, b = 3 en la operación SUM (debe dar V = 1)
//    alu_a = 2'b10; 
//    alu_b = 2'b11; 
//    alu_op = 2'b00; // Suma
//    #20;
//    $display("Flag Test - V, ALU result: %b, V: %b", alu_a + alu_b, dut.alu_inst.V);
//
//    // Bandera Signo: Cuando a = 1, b = 3 en la operación SUBTRACT (debe dar S = 1)
//    alu_a = 2'b01; 
//    alu_b = 2'b11; 
//    alu_op = 2'b01; // Resta
//    #20;
//    $display("Flag Test - S, ALU result: %b, S: %b", alu_a - alu_b, dut.alu_inst.S);
//
//    // Finalización
//    $finish;
//end
