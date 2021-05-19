class HelpScene extends Scene {
    HelpScene() {
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

        rectMode(CORNER);
        textAlign(LEFT);
        textSize(30);

        fill(255);
        String helpText = "Tap the corresponding finger when a note reaches the line to score.\n";
        text(helpText, 50, 50, width - 100, height - 100);

        if (interfaces.length == 0)
            return;
        
        interfaces[currentInterface].Draw();
    }
}