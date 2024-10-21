const unsigned long TIMEOUT = 3000; // 3 segundos en milisegundos
const unsigned long MAX_INACTIVITY = 12000; // 12 segundos en milisegundos
const int BAUD_RATE = 9600;

unsigned long inactivityStartTime = 0;  // Para contar el tiempo de inactividad acumulado

void setup() {
  // Iniciar la comunicación UART a 9600 baudios
  Serial.begin(BAUD_RATE);
  // Configurar el LED_BUILTIN como salida para mostrar el resultado de la prueba
  pinMode(LED_BUILTIN, OUTPUT);
  // Apagar el LED al inicio
  digitalWrite(LED_BUILTIN, LOW);
  // Inicializar el tiempo de inactividad
  inactivityStartTime = millis();
}

void loop() {
  // Dato de prueba que se va a enviar (4 bits menos significativos)
  byte dataToSend = 0b1010;  // Ejemplo de dato a enviar (4 bits)

  // Enviar el dato por UART (TX pin 1)
  Serial.write(dataToSend);

  // Esperar la respuesta con timeout
  unsigned long startTime = millis();
  bool received = false;

  while (millis() - startTime < TIMEOUT) {
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

      received = true;
      inactivityStartTime = millis();  // Reiniciar el tiempo de inactividad ya que hubo comunicación
      break;
    }
  }

  if (!received) {
    // Si no se recibe nada en 3 segundos, apagar el LED
    digitalWrite(LED_BUILTIN, LOW);
    Serial.end();
    delay(100);  // Pequeña pausa antes de reiniciar la comunicación
    Serial.begin(BAUD_RATE);
  }

  // Verificar si la inactividad acumulada supera los 12 segundos
  if (millis() - inactivityStartTime >= MAX_INACTIVITY) {
    CerrarComs();
    return;  // Terminar el loop
  }

  // Pausar antes de enviar el siguiente dato
  delay(5000);  // Esperar 5 segundos antes de repetir
}

// Función para cerrar la comunicación y hacer parpadear el LED
void CerrarComs() {
  // Cerrar la comunicación UART
  Serial.end();

  // Hacer que el LED_BUILTIN parpadee 5 veces para indicar que la comunicación se cerró
  for (int i = 0; i < 5; i++) {
    digitalWrite(LED_BUILTIN, HIGH);  // Encender el LED
    delay(500);                       // Esperar 500 ms
    digitalWrite(LED_BUILTIN, LOW);   // Apagar el LED
    delay(500);                       // Esperar 500 ms
  }
}
