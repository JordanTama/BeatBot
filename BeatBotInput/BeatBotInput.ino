const bool usingJoystick = false;

const int aPin = A0;
const int bPin = A1;
const int cPin = A2;
const int dPin = A3;

const int threshold = 256;

void setup()
{
    Serial.begin(9600);
}

void loop()
{
    bool aDown = usingJoystick ? analogRead(aPin) < threshold / 2 : analogRead(aPin) >= 1023 - threshold;
    bool bDown = usingJoystick ? analogRead(aPin) >= 1023 - threshold / 2 : analogRead(bPin) >= 1023 - threshold;
    bool cDown = usingJoystick ? analogRead(bPin) < threshold / 2 : analogRead(cPin) >= 1023 - threshold;
    bool dDown = usingJoystick ? analogRead(bPin) >= 1023 - threshold / 2 : analogRead(dPin) >= 1023 - threshold;

    if (aDown)
        Serial.println("a");

    if (bDown)
        Serial.println("b");

    if (cDown)
        Serial.println("c");

    if (dDown)
        Serial.println("d");
}
