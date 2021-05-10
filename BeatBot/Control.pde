class Control
{
    // TODO: Need to figure out how to link control to an arduino pin component
    
    private int id;
    
    public int GetId()
    {
        return id;
    }
    
    public Control(int id)
    {
        this.id = id;
    }
    
    public boolean IsDown()
    {
        // Replace this with state of the arduino sensor.
        return false;
    }
}
