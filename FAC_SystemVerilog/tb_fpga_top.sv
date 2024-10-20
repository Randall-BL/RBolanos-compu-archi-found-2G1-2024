`timescale 1ns / 1ps

module tb_fpga_top;

    // Parámetros
    parameter CLK_PERIOD = 20; // 50MHz clock
    parameter BAUD_RATE = 9600;
    parameter BIT_PERIOD = 1000000000 / BAUD_RATE; // Periodo de un bit en ns

    // Señales de prueba
    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    reg send;
    wire tx;
    wire [1:0] data_out;
    wire valid;
    wire busy;

    // Instancia del módulo bajo prueba
    fpga_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(tx), // Conectamos tx directamente a rx para simular un loopback
        .data_in(data_in),
        .send(send),
        .tx(tx),
        .data_out(data_out),
        .valid(valid),
        .busy(busy)
    );

    // Generación de reloj
    always #(CLK_PERIOD/2) clk = ~clk;

    // Tarea para enviar un byte
    task send_byte;
        input [7:0] byte_to_send;
        begin
            @(posedge clk);
            data_in = byte_to_send;
            send = 1;
            @(posedge clk);
            send = 0;
            // Esperamos hasta que se complete la transmisión
            wait(!busy);
            $display("Sent byte: %b", byte_to_send);
        end
    endtask

    // Tarea para verificar el dato recibido
    task verify_received;
        input [7:0] sent_byte;
        input [1:0] expected_decoded;
        begin
            // Esperar hasta que la señal `valid` esté alta
            wait(valid);
            #1; // Pequeño retraso para estabilización
            if (data_out == expected_decoded)
                $display("PASS: Sent %b, Received decoded %b", sent_byte, data_out);
            else
                $display("FAIL: Sent %b, Expected decoded %b, Got %b", sent_byte, expected_decoded, data_out);
            // Agregar una aserción para mayor robustez
            assert(data_out == expected_decoded) else 
                $fatal("ERROR: Sent %b, Expected decoded %b, Got %b", sent_byte, expected_decoded, data_out);
        end
    endtask

    // Secuencia de prueba
    initial begin
        // Inicialización
        clk = 0;
        rst_n = 0;
        data_in = 8'd0;
        send = 0;

        // Reset con tiempo para estabilización
        #100;
        rst_n = 1;

        // Prueba 1: Enviar 0001 (debe decodificar a 00)
        send_byte(8'b00000001);
        verify_received(8'b00000001, 2'b00);

        // Prueba 2: Enviar 0101 (debe decodificar a 01)
        send_byte(8'b00000101);
        verify_received(8'b00000101, 2'b01);

        // Prueba 3: Enviar 1001 (debe decodificar a 10)
        send_byte(8'b00001001);
        verify_received(8'b00001001, 2'b10);

        // Prueba 4: Enviar 1101 (debe decodificar a 11)
        send_byte(8'b00001101);
        verify_received(8'b00001101, 2'b11);

        // Fin de la simulación
        #1000 $finish;
    end

    // Monitor opcional para rastrear valores de interés
    initial begin
        $monitor("Time=%0t: data_out=%b, valid=%b, busy=%b", $time, data_out, valid, busy);
    end

endmodule
