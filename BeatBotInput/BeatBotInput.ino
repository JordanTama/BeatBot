const int aPin = A0;
const int bPin = A1;
const int cPin = A2;
const int dPin = A3;

const int threshold = 768;

void setup()
{
    Serial.begin(9600);
}

void loop()
{
    if (analogRead(aPin) > threshold)
        Serial.println("a");

    if (analogRead(bPin) > threshold)
        Serial.println("b");

    if (analogRead(cPin) > threshold)
        Serial.println("c");

    if (analogRead(dPin) > threshold)
        Serial.println("d");
}
