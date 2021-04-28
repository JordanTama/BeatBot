class State
{
    public Menu currentMenu;
    
    private PApplet sketch;
    
    public State(PApplet sketch)
    {
        this.sketch = sketch;
    }
    
    public void Start(Menu startMenu)
    {
        currentMenu = startMenu;
    }
    
    public void Draw()
    {
        currentMenu.Draw();
    }
}
