#include <Wire.h>
#include <SparkFunHTU21D.h>

HTU21D mySensor;

void setup() {
  Serial.begin(9600);
  Wire.begin();

  Serial.println("HTU21D Test Starting...");

  mySensor.begin();

  // Allow sensor to stabilize
  delay(5000);

  // Throw away first readings
  mySensor.readTemperature();
  mySensor.readHumidity();

  Serial.println("HTU21D initialized.");
}


void loop() {
  float humidity = mySensor.readHumidity();
  float temperature = mySensor.readTemperature();
  float tempF = temperature * 9.0 / 5.0 + 32.0;

  Serial.print(" | ");
  Serial.print(tempF);
  Serial.println(" °F");


  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print(" °C | ");

  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.println(" %");

  delay(2000);
}
