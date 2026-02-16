#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

String incoming = "";

float latestTemp = 0.0;
float latestHum = 0.0;

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
  Serial1.begin(9600, SERIAL_8N1, 17, 16);

  delay(1000);
  Serial.println("Starting StillCold Communication Node with BLE...");

  BLEDevice::init("StillCold");

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService("12345678-1234-1234-1234-1234567890ab");

  // Temperature characteristic
  pTemperatureCharacteristic = pService->createCharacteristic(
                                  "abcd1234-5678-1234-5678-abcdef123456",
                                  BLECharacteristic::PROPERTY_READ
                                );

  // Humidity characteristic
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
  while (Serial1.available()) {
    char c = Serial1.read();

    if (c == '\n') {

      if (sscanf(incoming.c_str(), "T=%f,H=%f", &latestTemp, &latestHum) == 2) {
        Serial.print("Stored -> Temp: ");
        Serial.print(latestTemp);
        Serial.print(" C | Humidity: ");
        Serial.print(latestHum);
        Serial.println(" %");

        String tempString = String(latestTemp, 2);
        String humString  = String(latestHum, 2);

        pTemperatureCharacteristic->setValue(tempString.c_str());
        pHumidityCharacteristic->setValue(humString.c_str());

      } else {
        Serial.println("Parse error");
      }

      incoming = "";
    } else {
      incoming += c;
    }
  }
}
