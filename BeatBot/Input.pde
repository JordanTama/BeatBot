class Controller
{    
    Serial port;
    Control[] controls;
    
    final char[][] inputs = new char[][] {
        new char[] {'a', 'A'},
        new char[] {'b', 'B'},
        new char[] {'c', 'C'},
        new char[] {'d', 'D'}
    };
    
    
    Controller()
    {        
        controls = new Control[] {
            new Control(),
            new Control(),
            new Control(),
            new Control()
        };
        
        if (Serial.list().length > 0)
            port = new Serial(BeatBot.instance, Serial.list()[0], 9600);
    }
    
    
    void Update()
    {
        for (Control control : controls)
            control.GetValue();

        if (port == null)
            return;
            
        while (port.available() > 0)
        {
            char character = port.readChar();
            
            for (int i = 0; i < inputs.length; i++)
            {
                if (inputs[i][0] == character)
                    controls[i].TrySet();
                else if (inputs[i][1] == character)
                    controls[i].Release();
            }
        }
    }
    
    void Override(int index, boolean pressed)
    {
        if (index < 0 || index >= inputs.length)
            return;

        if (port != null)
        {
            port.write(inputs[index][pressed ? 0 : 1]);
        }
        else
        {
            if (pressed)
                controls[index].TrySet();
            else
                controls[index].Release();
        }
    }
    
    boolean[] GetValues()
    {
        boolean[] values = new boolean[controls.length];
        
        for (int i = 0; i < controls.length; i++)
            values[i] = controls[i].GetValue();
            
        return values;
    }
}


class Control
{
    boolean isDown;
    boolean value;
    
    void TrySet()
    {
        if (isDown)
            return;

        value = true;
        isDown = true;
    }
    
    void Release()
    {
        isDown = false;
        value = false;
    }
    
    boolean GetValue()
    {
        boolean value = this.value;
        this.value = false;
        return value;
    }
}
