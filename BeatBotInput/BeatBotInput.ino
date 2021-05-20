const bool usingJoystick = true;

const int xPin = A0;
const int yPin = A1;

const int aPin = A2;
const int bPin = A3;
const int cPin = A4;
const int dPin = A5;

const int joystickThreshold = 256;
const int microphoneThreshold = 4;

void setup()
{
    Serial.begin(9600);
}

void loop()
{
    bool aDown = usingJoystick ? analogRead(xPin) < joystickThreshold / 2 : abs(analogRead(aPin) - 32) >= microphoneThreshold;
    bool bDown = usingJoystick ? analogRead(xPin) >= 1023 - joystickThreshold / 2 : abs(analogRead(bPin) - 32) >= microphoneThreshold;
    bool cDown = usingJoystick ? analogRead(yPin) < joystickThreshold / 2 : abs(analogRead(cPin) - 32) >= microphoneThreshold;
    bool dDown = usingJoystick ? analogRead(yPin) >= 1023 - joystickThreshold / 2 : abs(analogRead(dPin) - 32) >= microphoneThreshold;

    Serial.println(aDown ? "a" : "A");
    Serial.println(bDown ? "b" : "B");
    Serial.println(cDown ? "c" : "C");
    Serial.println(dDown ? "d" : "D");
}
