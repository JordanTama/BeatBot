abstract class Interface
{
    abstract void Draw();
    abstract void Select(int index);
}

abstract class InterfaceButton
{
    boolean selected;

    final float buttonAngle = -PI * 0.22;

    abstract void Invoke();

    void Select() {
        if (selected) {
            Invoke();
            selected = false;
            Resources.confirmSound.play();
            return;
        }

        selected = true;
        Resources.selectSound.play();
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

        strokeWeight(0);
        SetColour(buttonIndex);

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

    void SetColour(int buttonIndex)
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
            
            default:
                fill(255);
                break;
        };
    }
}

class LabelButton extends InterfaceButton
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

class ImageButton extends InterfaceButton
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