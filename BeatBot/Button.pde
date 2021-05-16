class Button
{
    private Menu next;
    private State state;
    
    public String name;
    public boolean highlighted;
    
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
        if (highlighted)
            state.currentMenu = next;
        else
            highlighted = true;
    }
    
    public void OnDeselect()
    {
        highlighted = false;
    }
}
