void setup() {
  // Iniciar la comunicación UART a 115200 baudios
  Serial.begin(9600);

  // Configurar el LED_BUILTIN como salida para mostrar el resultado de la prueba
  pinMode(LED_BUILTIN, OUTPUT);

  // Apagar el LED al inicio
  digitalWrite(LED_BUILTIN, LOW);

  // Esperar un tiempo para estabilizar la comunicación serial
  delay(1000);
}

void loop() {
  // Dato de prueba que se va a enviar (4 bits menos significativos)
  byte dataToSend = 0b1010;  // Ejemplo de dato a enviar (4 bits)

  // Enviar el dato por UART (TX pin 1)
  Serial.write(dataToSend);

  // Esperar un momento para dar tiempo a recibir la respuesta (loopback será inmediato)
  delay(1000);

  // Verificar si hay datos disponibles en el buffer de recepción (RX pin 0)
  if (Serial.available() > 0) {
    // Leer el byte recibido desde RX (pin 0)
    byte receivedData = Serial.read();

    // Verificar si el dato recibido es igual al enviado
    if (receivedData == dataToSend) {
      // Si los datos coinciden, encender el LED
      digitalWrite(LED_BUILTIN, HIGH);
    } else {
      // Si los datos no coinciden, apagar el LED
      digitalWrite(LED_BUILTIN, LOW);
    }
  } else {
    // Si no se recibe nada, mantener el LED apagado
    digitalWrite(LED_BUILTIN, LOW);
  }

  // Pausar antes de enviar el siguiente dato
  delay(5000);  // Esperar 5 segundos antes de repetir
}


