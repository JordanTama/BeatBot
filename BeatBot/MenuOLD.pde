class Menu
{
    private State state;
    private String name;
    private Button[] buttons;
    
    private PImage icon;
    private PImage backIcon;
    private PFont font;
    private SoundFile nextSound;
    private SoundFile backSound;
    
    private final float buttonAngle = -PI * 0.22;
    private float buttonArea;
    private float buttonWidth;
    
    
    
    public Menu(State state, String name)
    {
        this.state = state;
        this.name = name;
        
        buttons = new Button[0];
        
        icon = loadImage("logo.png");
        backIcon = loadImage("back.png");
        font = createFont("united-kingdom.otf", 1);
        nextSound = new SoundFile(state.sketch, "confirm.wav");
        backSound = new SoundFile(state.sketch, "back.wav");
    }
    
    
    public void Draw()
    {
        background(0);
        
        // Draw buttons
        buttonArea = (float) height / (tan(-buttonAngle));
        buttonWidth = (buttonArea / buttons.length) * sin(-buttonAngle);
        
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttons[i] == null)
                DrawSpace(i);
            else
                DrawButton(i);
        }
        
        // Draw icons
        float aspect = icon.width / icon.height;
        float sizeMax = width * .4;
        
        float xPos = width * 0.05;
        float yPos = height * 0;
        
        image(icon, xPos, yPos, sizeMax, sizeMax * aspect);
        
        float backSize = 70;
        image(backIcon, width - backSize, height - backSize, backSize, backSize);
        
        textAlign(CENTER, TOP);
        fill(202, 109, 228, 255);
        textFont(font);
        textSize(40);
        text(name, xPos, yPos + sizeMax, sizeMax, 100);
    }
    
    private void DrawButton(int index)
    {
        pushMatrix();
        
        translate(width - buttonArea + (buttonArea / (float) buttons.length) * index, height);
        rotate(buttonAngle);
        
        strokeWeight(0);
        SetColour(index);
        
        float rectLength = ((height / (float) buttons.length) * (buttons.length - index)) / (sin(-buttonAngle));//sqrt(pow(width, 2) + pow(height, 2));
        rect(0, 0, rectLength, buttonWidth);
        
        if (buttons[index].highlighted)
            fill(255);
        else
            fill(0);
        
        textSize(50);
        textAlign(CENTER, CENTER);
        text(buttons[index].name, 0, 0, rectLength, buttonWidth);
        
        popMatrix();
    }
    
    private void DrawSpace(int index)
    {
        pushMatrix();
        
        translate(width - buttonArea + (buttonArea / (float) buttons.length) * index, height);
        rotate(buttonAngle);
        
        strokeWeight(0);
        fill(0);
        
        rect(0, 0, sqrt(pow(width, 2) + pow(height, 2)), buttonWidth); 
        
        popMatrix();
    }
    
    private void SetColour(int buttonIndex)
    {
        switch (buttonIndex)
        {
            case 0:
                fill(37, 255, 195, 255);
                break;
                
            case 1:
                fill(14, 20, 252, 255);
                break;
                
            case 2:
                fill(236, 62, 200, 255);
                break;
                
            case 3:
                fill(114, 8, 188, 255);
                break;
        };
    }
    
    
    public void SetButtons(Button[] buttons)
    {
        this.buttons = buttons;
        
        for (Button button : buttons)
        {
            if (button == null)
                continue;
            
            button.SetState(state);
        }
    }
    
    public void Select(int index)
    {
        if (index < 0 || index > buttons.length - 1 || buttons[index] == null)
            return;
        
        if (index == buttons.length - 1)
            backSound.play();
        else
            nextSound.play();
            
        buttons[index].OnSelect();
        
        for (Button button : buttons)
        {
            if (button == buttons[index])
                continue;
            
            button.OnDeselect();
        }
    }
}
