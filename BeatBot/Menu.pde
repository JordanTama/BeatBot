class MenuScene extends Scene
{
    MenuInterface[] interfaces;
    int currentInterface;
    
    void HandleInput(boolean[] inputs) {}
    void Draw() {}
}

class MenuInterface extends Interface
{
    InterfaceButton[] buttons;
    
    
    void Draw() {}
}

class InterfaceNavButton extends InterfaceButton
{
    int sceneIndex;
    
    void OnPress() {}
}
