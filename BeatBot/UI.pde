class Interface
{
    Button[] buttons;

    public Interface(Button[] buttons) {
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

        for (Button button : buttons){
            if (button == null || button == buttons[index])
                continue;
            
            button.Deselect();
        }

        buttons[index].Select();
    }

    void HandleInput(boolean[] inputs) {
        for (int i = 0; i < inputs.length; i++)
        {
            if (!inputs[i])
                continue;

            Select(i);
            return;
        }
    }
}

abstract class Button
{
    boolean selected;

    final float buttonAngle = -PI * 0.22;

    abstract void Invoke();

    void Select() {
        if (selected) {
            Invoke();
            selected = false;
            Resources.confirmSound.play(1, 0, BeatBot.volume);
            return;
        }

        selected = true;
        Resources.selectSound.play(1, 0, BeatBot.volume);
    }
    
    void Deselect() {
        selected = false;
    }

    float CalculateButtonWidth(int totalButtons)
    {
        return (CalculateTotalWidth() / totalButtons) * sin(-buttonAngle);
    }

    float CalculateTotalWidth()
    {
        return (float) height / (tan(-buttonAngle));
    }

    float CalculateRectLength(int buttonIndex, int totalButtons)
    {
        return ((height / (float) totalButtons) * (totalButtons - buttonIndex)) / (sin(-buttonAngle));
    }

    void Draw(int buttonIndex, int totalButtons)
    {
        float totalWidth = CalculateTotalWidth();
        float buttonWidth = CalculateButtonWidth(totalButtons);
        
        PushMatrix(buttonIndex, totalButtons);

        rectMode(CORNER);
        strokeWeight(0);
        Resources.SetColour(buttonIndex);

        float rectLength = CalculateRectLength(buttonIndex, totalButtons);
        rect(0, 0, rectLength, buttonWidth);

        popMatrix();
    }

    void PushMatrix(int buttonIndex, int totalButtons)
    {
        pushMatrix();

        float totalWidth = CalculateTotalWidth();

        translate(width - totalWidth + (totalWidth / (float) totalButtons) * buttonIndex, height);
        rotate(buttonAngle);
    }
}

class LabelButton extends Button
{
    String label;


    LabelButton() {}

    LabelButton(String label)
    {
        this.label = label;
    }


    void Invoke() {}

    @Override
    void Draw(int buttonIndex, int totalButtons)
    {
        super.Draw(buttonIndex, totalButtons);

        PushMatrix(buttonIndex, totalButtons);

        if (selected)
            fill(255);
        else
            fill(0);
        
        textSize(50);
        textAlign(CENTER, CENTER);
        text(label, 0, 0, CalculateRectLength(buttonIndex, totalButtons), CalculateButtonWidth(totalButtons));
        
        popMatrix();
    }
}

class ImageButton extends Button
{
    PImage icon;


    ImageButton() {}

    ImageButton(PImage icon) {
        this.icon = icon;
    }


    void Invoke() {}

    @Override
    void Draw(int buttonIndex, int totalButtons) {
        super.Draw(buttonIndex, totalButtons);

        PushMatrix(buttonIndex, totalButtons);
        // rotate(-buttonAngle);

        if (selected)
            tint(255);
        else
            tint(0);

        float rectLength = CalculateRectLength(buttonIndex, totalButtons);
        float buttonWidth = CalculateButtonWidth(totalButtons);

        translate(rectLength / 2, buttonWidth / 2);
        rotate(-buttonAngle);

        imageMode(CENTER);
        image(icon, 0, 0, 50, 50);
        
        popMatrix();

        tint(255);
    }
}