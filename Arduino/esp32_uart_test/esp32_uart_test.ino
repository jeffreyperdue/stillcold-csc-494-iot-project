String incoming = "";

float latestTemp = 0.0;
float latestHum = 0.0;

void setup() {
  Serial.begin(115200);
  Serial1.begin(9600, SERIAL_8N1, 17, 16);  // RX = D7 (GPIO17), TX = D6 (GPIO16)
}

void loop() {
  while (Serial1.available()) {
    char c = Serial1.read();

    if (c == '\n') {

      if (sscanf(incoming.c_str(), "T=%f,H=%f", &latestTemp, &latestHum) == 2) {
        Serial.print("Stored -> Temp: ");
        Serial.print(latestTemp);
        Serial.print(" C | Humidity: ");
        Serial.print(latestHum);
        Serial.println(" %");
      } else {
        Serial.println("Parse error");
      }

      incoming = "";
    } else {
      incoming += c;
    }
  }
}
