class Controller
{    
    BeatBot program;
    Serial port;
    Control[] controls;
    
    
    Controller(BeatBot program)
    {
        this.program = program;
        
        controls = new Control[] {
            new Control(),
            new Control(),
            new Control(),
            new Control()
        };
        
        if (Serial.list().length > 0)
            port = new Serial(program, Serial.list()[0], 9600);
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
            switch (character)
            {
                case 'a':
                    controls[0].TrySet();
                    break;
                    
                case 'b':
                    controls[1].TrySet();
                    break;
                    
                case 'c':
                    controls[2].TrySet();
                    break;
                    
                case 'd':
                    controls[3].TrySet();
                    break;

                case 'A':
                    controls[0].Release();
                    break;
                    
                case 'B':
                    controls[1].Release();
                    break;
                    
                case 'C':
                    controls[2].Release();
                    break;
                    
                case 'D':
                    controls[3].Release();
                    break;
            }
        }
    }
    
    void Override(int index)
    {
        if (index < 0 || index >= controls.length)
            return;

        controls[index].TrySet();
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
