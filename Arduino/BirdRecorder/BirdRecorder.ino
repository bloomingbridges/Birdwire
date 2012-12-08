
int sensorPin = A0;
int led = 13;
int sensorValue;
char incomingBuffer[20];
String newValue;

int NOISE_THRESHOLD = 530;
int DIT_LOW = 540;
int DIT_HIGH = 560;
int DAH_LOW = 620;
int DAH_HIGH = 640;

bool DEBUG = false;
String debugLine;

void setup() {
  Serial.begin(9600);
  pinMode(led, OUTPUT);
}

void loop() {
  
  if (Serial.available() > 0) {
    Serial.readBytesUntil('\n', incomingBuffer, 4);
    newValue = incomingBuffer;
    switch (newValue[0]) {
      case 'A':
        debugLine = "NEW VALUE RECEIVED FOR DIT_LOW " + newValue.substring(1);
        DIT_LOW = convertToInt(newValue.substring(1));
        NOISE_THRESHOLD = DIT_LOW - 20;
        break;
      case 'B':
        debugLine = "NEW VALUE RECEIVED FOR DIT_HIGH " + newValue.substring(1);
        DIT_HIGH = convertToInt(newValue.substring(1));
        break;
      case 'X':
        debugLine = "NEW VALUE RECEIVED FOR DAH_LOW " + newValue.substring(1);
        DAH_LOW = convertToInt(newValue.substring(1));
        break;
      case 'Y':
        debugLine = "NEW VALUE RECEIVED FOR DAH_HIGH " + newValue.substring(1);
        DAH_HIGH = convertToInt(newValue.substring(1));
        break;
      case 'N':
        debugLine = "NEW VALUE RECEIVED FOR NOISE_THRESHOLD " + newValue.substring(1);
        NOISE_THRESHOLD = convertToInt(newValue.substring(1));
        break;
    }
    if (DEBUG) {
      Serial.println(incomingBuffer);
      Serial.println(debugLine);
      debugLine = "";
      Serial.print("THRESHOLDS: ");
      Serial.print(DIT_LOW);
      Serial.print(", ");
      Serial.print(DIT_HIGH);
      Serial.print(", ");
      Serial.print(DAH_LOW);
      Serial.print(", ");
      Serial.print(DAH_HIGH);
      Serial.print(" ~ ");
      Serial.println(NOISE_THRESHOLD);
    }
  }
  
  sensorValue = analogRead(sensorPin);  
  if(sensorValue > NOISE_THRESHOLD){
    broadcastMeasurements(sensorValue, DEBUG);
  }
}

int convertToInt(String v) {
  char number[4]; 
  v.toCharArray(number, 4);
  return atoi(number);
}

void broadcastMeasurements(int sensorValue, bool debug) {
  
  if (sensorValue > DAH_LOW && sensorValue < DAH_HIGH){  
    debugLine = " PECK";   
    Serial.write(2);
    digitalWrite(led, HIGH);
    delay(100);
    digitalWrite(led, LOW);
  }  
  if (sensorValue > DIT_LOW && sensorValue < DIT_HIGH) {
    debugLine = " peck"; 
    Serial.write(1);
    digitalWrite(led, HIGH);
    delay(100);
    digitalWrite(led, LOW);
  }
  
  if (debug) {
    Serial.print(sensorValue);
    Serial.println(debugLine);
  }
  
}
