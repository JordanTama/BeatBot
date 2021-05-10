class Button
{
    private Menu next;
    private State state;
    
    public String name;
    
    public Button(Menu next, String name)
    {
        this.next = next;
        this.name = name;
    }
 
    public void SetState(State state)
    {
        this.state = state;
    }
    
    public void OnSelect()
    {
        state.currentMenu = next;
    }
}
