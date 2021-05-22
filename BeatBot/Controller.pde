class Controller
{    
    private Control[] controls;
    
    public void Initialize()
    {        
        controls = new Control[] {
            new Control(0),
            new Control(1),
            new Control(2),
            new Control(3)
        };
    }
    
    public int GetFingerInput()
    {
        for (Control control : controls)
        {
            if (control.IsDown())
                return control.id;
        }
        
        return -1;
    }
}
