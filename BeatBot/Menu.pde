class MenuScene extends Scene
{
    int currentInterface;

    public MenuScene()
    {
        interfaces = new Interface[] {
            new MenuInterface(new InterfaceButton[] {
                new InterfaceNavButton(this, 1, "Easy"),
                new InterfaceNavButton(this, 2, "Medium"),
                new InterfaceNavButton(this, 3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new InterfaceButton[] {
                null,
                new InterfaceNavButton(this, 2, "Medium"),
                new InterfaceNavButton(this, 3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new InterfaceButton[] {
                new InterfaceNavButton(this, 1, "Easy"),
                null,
                new InterfaceNavButton(this, 3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new InterfaceButton[] {
                new InterfaceNavButton(this, 1, "Easy"),
                new InterfaceNavButton(this, 2, "Medium"),
                null,
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
        };
    }
    
    void HandleInput(boolean[] inputs) {
        if (interfaces.length == 0)
            return;

        for (int i = 0; i < inputs.length; i++)
        {
            if (!inputs[i])
                continue;

            interfaces[currentInterface].Select(i);
            return;
        }
    }

    void Draw() {
        background(0);

        // Draw icons
        float aspect = Resources.logoImage.width / Resources.logoImage.height;
        float sizeMax = width * .4;
        float xPos = width * 0.25;
        float yPos = height * 0.25;

        imageMode(CENTER);
        image(Resources.logoImage, xPos, yPos, sizeMax, sizeMax * aspect);

        textAlign(CENTER, TOP);
        fill(202, 109, 228, 255);
        textSize(40);
        text("Main Menu", xPos - sizeMax / 2, yPos + sizeMax / 2, sizeMax, 100);
        
        // Draw Interfaces
        if (interfaces.length == 0)
            return;
        
        interfaces[currentInterface].Draw();
    }

    void ChangeInterface(int index)
    {
        currentInterface = index;
    }
}

class MenuInterface extends Interface
{
    InterfaceButton[] buttons;
    
    public MenuInterface(InterfaceButton[] buttons)
    {
        this.buttons = buttons;
    }
    
    void Draw() {
        for (int i = 0; i < buttons.length; i++) {
            if (buttons[i] == null)
                continue;
            buttons[i].Draw(i, buttons.length);
        }
    }

    void Select(int index)
    {
        if (index < 0 || index >= buttons.length || buttons[index] == null)
            return;

        for (InterfaceButton button : buttons){
            if (button == null || button == buttons[index])
                continue;
            
            button.Deselect();
        }

        buttons[index].OnPress();
    }
}

class InterfaceNavButton extends LabelButton
{
    Scene scene;
    int targetIndex;

    InterfaceNavButton(Scene scene, int targetIndex, String label)
    {
        super(label);

        this.scene = scene;
        this.targetIndex = targetIndex;
    }
    
    void OnPress() {
        if (selected)
        {
            scene.ChangeInterface(targetIndex);
            selected = false;
        }
        else
        {
            super.OnPress();
        }
    }
}

class InterfaceNavImageButton extends ImageButton
{
    Scene scene;
    int targetIndex;

    InterfaceNavImageButton(Scene scene, int targetIndex, PImage icon)
    {
        super(icon);

        this.scene = scene;
        this.targetIndex = targetIndex;
    }
    
    void OnPress() {
        if (selected)
        {
            scene.ChangeInterface(targetIndex);
            selected = false;
        }
        else
        {
            super.OnPress();
        }
    }
}