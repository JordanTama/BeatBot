class ScoreScene extends Scene {
    ScoreScene() {
        interfaces = new Interface[] {
            new Interface(new Button[] {
                null,
                null,
                null,
                new SceneNavImageButton(0, Resources.homeImage)
            })
        };
    }

    void HandleInput(boolean[] inputs) {
        if (interfaces.length == 0)
            return;

        interfaces[currentInterface].HandleInput(inputs);
    }

    void Draw() {
        background(0);

        rectMode(CENTER);
        textAlign(CENTER);
        textSize(40);

        fill(255);
        text("Score " + (int) (BeatBot.score), width / 2, height / 2, width, 100);

        if (interfaces.length == 0)
            return;
        
        interfaces[currentInterface].Draw();
    }
}

class SceneNavImageButton extends ImageButton
{
    int targetIndex;

    SceneNavImageButton(int targetIndex, PImage icon)
    {
        super(icon);

        this.targetIndex = targetIndex;
    }
    
    void Invoke() {
        SceneManager.Load(targetIndex);
        selected = false;
    }
}