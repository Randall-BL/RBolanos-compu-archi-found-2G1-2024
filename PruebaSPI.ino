void setup() {
  // Inicia la comunicación serie para ver el resultado en el monitor
  Serial.begin(9600);
  // Mensaje de inicio
  Serial.println("Iniciando prueba UART...");
}

void loop() {
  // Enviar el mensaje por UART
  Serial.println("Prueba de transmisión UART");

  // Espera un segundo
  delay(1000);

  // Verificar si se ha recibido algún dato
  if (Serial.available() > 0) {
    // Leer cada byte recibido
    String receivedData = Serial.readString();
    
    // Imprimir los datos recibidos
    Serial.print("Datos recibidos: ");
    Serial.println(receivedData);
  }

  // Esperar antes de la siguiente iteración
  delay(1000);
}
