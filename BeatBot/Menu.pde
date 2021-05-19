class MenuScene extends Scene
{
    public MenuScene()
    {
        interfaces = new Interface[] {
            new Interface(new Button[] {
                new InterfaceNavButton(this, 1, "Play"),
                new InterfaceNavButton(this, 2, "Options"),
                new SceneNavButton(5, "Help"),
                null
            }),
            new Interface(new Button[] {
                new SceneNavButton(1, "Easy"),
                new SceneNavButton(2, "Medium"),
                new SceneNavButton(3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new Interface(new Button[] {
                new VolumeButton(-0.2),
                new VolumeButton(0.2),
                null,
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new Interface(new Button[] {
                null,
                null,
                null,
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            })
        };
    }

    void OnLoad() {
        Resources.menuTrack.loop(1, 0.01);
    }

    void OnUnload() {
        Resources.menuTrack.stop();
    }
    
    void HandleInput(boolean[] inputs) {
        if (interfaces.length == 0)
            return;

        interfaces[currentInterface].HandleInput(inputs);
    }

    void Draw() {
        background(0);

        // Draw icons
        float aspect = Resources.logoImage.width / Resources.logoImage.height;
        float sizeMax = width * .4;
        float xPos = width * 0.25;
        float yPos = height * 0.25;

        tint(255);
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
    
    void Invoke() {
        scene.ChangeInterface(targetIndex);
        selected = false;
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
    
    void Invoke() {
        scene.ChangeInterface(targetIndex);
        selected = false;
    }
}

class SceneNavButton extends LabelButton
{
    int targetIndex;

    SceneNavButton(int targetIndex, String label)
    {
        super(label);

        this.targetIndex = targetIndex;
    }
    
    void Invoke() {
        SceneManager.Load(targetIndex);
        selected = false;
    }
}

class VolumeButton extends ImageButton {
    float delta;

    VolumeButton(float delta) {
        this.delta = delta;
        this.icon = delta < 0 ? Resources.volumeDownImage : Resources.volumeUpImage;
    }

    void Invoke() {
        BeatBot.volume = constrain(BeatBot.volume + delta, 0.0, 1.0);;
    }
}