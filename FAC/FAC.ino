// Definir los pines para el TX y RX (en Arduino, pin 1 es TX y pin 0 es RX)
const int txPin = 1; // Pin de transmisión del Arduino (hacia RX de la FPGA)
const int rxPin = 0; // Pin de recepción del Arduino (desde TX de la FPGA)

void setup() {
  // Iniciar la comunicación UART a 9600 baudios
  Serial.begin(9600);

  // Mensaje de inicio en el monitor serial
  Serial.println("Iniciando comunicación UART con la FPGA...");
}

void loop() {
  // Datos a enviar al FPGA
  byte dataToSend = 0b11001100;  // Ejemplo de un byte de datos

  // Enviar el dato a la FPGA
  Serial.write(dataToSend);

  // Mostrar el dato enviado en el monitor serial
  Serial.print("Dato enviado a la FPGA: ");
  Serial.println(dataToSend, BIN);  // Mostrar en binario

  // Esperar respuesta de la FPGA
  delay(5000);  // Esperar un tiempo para que la FPGA procese y envíe respuesta

  // Verificar si hay datos disponibles para recibir desde la FPGA
  if (Serial.available() > 0) {
    // Leer el byte recibido desde la FPGA
    byte receivedData = Serial.read();

    // Mostrar el valor recibido en el monitor serial
    Serial.print("Dato recibido desde la FPGA: ");
    Serial.println(receivedData, BIN);  // Mostrar en formato binario
  }

  // Pausar antes de enviar el siguiente dato
  delay(5000);  // Esperar 5 segundos antes de enviar el próximo dato
}
