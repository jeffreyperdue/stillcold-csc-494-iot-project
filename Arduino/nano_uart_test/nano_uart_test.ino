#include <Wire.h>
#include <SparkFunHTU21D.h>

HTU21D mySensor;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  mySensor.begin();
  delay(1000);
}

void loop() {
  float humidity = mySensor.readHumidity();
  float temperature = mySensor.readTemperature();

  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("HTU21D read fail, skip");
    delay(2000);
    return;
  }

  Serial.print("T=");
  Serial.print(temperature, 2);
  Serial.print(",H=");
  Serial.print(humidity, 2);
  Serial.println();

  delay(2000);
}
