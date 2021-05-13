abstract class Interface
{
    abstract void Draw();
}

class MenuInterface extends Interface
{
    InterfaceButton[] buttons;
    
    
    void Draw() {}
}


abstract class InterfaceButton
{
}

class NavButton extends InterfaceButton
{
}
