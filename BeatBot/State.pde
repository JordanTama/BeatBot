class State
{
    public Menu currentMenu;
    
    private BeatBot sketch;
    
    public State(BeatBot sketch)
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
