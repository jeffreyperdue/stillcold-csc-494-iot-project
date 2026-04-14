#include <Wire.h>
#include <SparkFunHTU21D.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SDA_PIN 22  // D4 on XIAO ESP32-C6
#define SCL_PIN 23  // D5 on XIAO ESP32-C6

HTU21D mySensor;

BLECharacteristic *pTemperatureCharacteristic;
BLECharacteristic *pHumidityCharacteristic;
BLEServer *pServer;
bool deviceConnected = false;

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("Client connected.");
  }
  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("Client disconnected. Restarting advertising...");
    BLEDevice::startAdvertising();
  }
};

void setup() {
  Serial.begin(115200);
  delay(3000);
  Serial.println("StillCold — ESP32-only starting...");
  Wire.setPins(SDA_PIN, SCL_PIN);
  mySensor.begin(Wire);
  delay(1000);
  Serial.println("StillCold — ESP32-only starting...");

  BLEDevice::init("StillCold");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService("12345678-1234-1234-1234-1234567890ab");

  pTemperatureCharacteristic = pService->createCharacteristic(
    "abcd1234-5678-1234-5678-abcdef123456",
    BLECharacteristic::PROPERTY_READ
  );
  pHumidityCharacteristic = pService->createCharacteristic(
    "abcd5678-1234-5678-1234-abcdef654321",
    BLECharacteristic::PROPERTY_READ
  );

  pTemperatureCharacteristic->setValue("0.00");
  pHumidityCharacteristic->setValue("0.00");

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID("12345678-1234-1234-1234-1234567890ab");
  pAdvertising->start();

  Serial.println("BLE Ready.");
}

void loop() {
  float temperature = mySensor.readTemperature();
  float humidity    = mySensor.readHumidity();

  if (temperature >= 998 || humidity >= 998 || isnan(temperature) || isnan(humidity)) {
    Serial.println("HTU21D read error — skipping");
    delay(2000);
    return;
  }

  Serial.print("T="); Serial.print(temperature, 2);
  Serial.print(" C | H="); Serial.print(humidity, 2);
  Serial.println(" %");

  pTemperatureCharacteristic->setValue(String(temperature, 2).c_str());
  pHumidityCharacteristic->setValue(String(humidity, 2).c_str());

  delay(2000);
}