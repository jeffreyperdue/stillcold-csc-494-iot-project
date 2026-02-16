String incoming = "";

void setup() {
  Serial.begin(115200);     // USB debug
  Serial1.begin(9600);      // UART from Nano
}

void loop() {
  while (Serial1.available()) {
    char c = Serial1.read();

    if (c == '\n') {
      Serial.print("Received: ");
      Serial.println(incoming);
      incoming = "";
    } else {
      incoming += c;
    }
  }
}
