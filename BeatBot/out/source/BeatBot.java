import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BeatBot extends PApplet {

// LIBRARIES




// MEMBER VARIABLES
static Controller controller;
static BeatBot instance;


// EVENT FUNCTIONS
public void setup()
{
    instance = this;

    Resources.Initialise();
    SceneManager.Initialise();

    controller = new Controller();

    
    textFont(Resources.font);
}

public void draw()
{
    HandleInput();
    SceneManager.Draw();
}

public void keyPressed()
{    
    switch (key)
    {
        case '7':
            controller.Override(0, true);
            break;
            
        case '8':
            controller.Override(1, true);
            break;
            
        case '9':
            controller.Override(2, true);
            break;
            
        case '0':
            controller.Override(3, true);
            break;
    }
}

public void keyReleased()
{
    switch (key)
    {
        case '7':
            controller.Override(0, false);
            break;
            
        case '8':
            controller.Override(1, false);
            break;
            
        case '9':
            controller.Override(2, false);
            break;
            
        case '0':
            controller.Override(3, false);
            break;
    }
}

// FUNCTIONS
public void HandleInput()
{
    boolean[] inputs = controller.GetValues();
    SceneManager.HandleInput(inputs);

    controller.Update();
}
class Controller
{    
    Serial port;
    Control[] controls;
    
    final char[][] inputs = new char[][] {
        new char[] {'a', 'A'},
        new char[] {'b', 'B'},
        new char[] {'c', 'C'},
        new char[] {'d', 'D'}
    };
    
    
    Controller()
    {        
        controls = new Control[] {
            new Control(),
            new Control(),
            new Control(),
            new Control()
        };
        
        if (Serial.list().length > 0)
            port = new Serial(BeatBot.instance, Serial.list()[0], 9600);
    }
    
    
    public void Update()
    {
        for (Control control : controls)
            control.GetValue();

        if (port == null)
            return;
            
        while (port.available() > 0)
        {
            char character = port.readChar();
            
            for (int i = 0; i < inputs.length; i++)
            {
                if (inputs[i][0] == character)
                    controls[i].TrySet();
                else if (inputs[i][1] == character)
                    controls[i].Release();
            }
        }
    }
    
    public void Override(int index, boolean pressed)
    {
        if (index < 0 || index >= inputs.length)
            return;

        if (port != null)
        {
            port.write(inputs[index][pressed ? 0 : 1]);
        }
        else
        {
            if (pressed)
                controls[index].TrySet();
            else
                controls[index].Release();
        }
    }
    
    public boolean[] GetValues()
    {
        boolean[] values = new boolean[controls.length];
        
        for (int i = 0; i < controls.length; i++)
        {
            values[i] = controls[i].GetValue();
            if (values[i])
                println("Input '" + inputs[i][0] + "' detected.");
        }
            
        return values;
    }
}


class Control
{
    boolean isDown;
    boolean value;
    
    public void TrySet()
    {
        if (isDown)
            return;

        value = true;
        isDown = true;
    }
    
    public void Release()
    {
        isDown = false;
        value = false;
    }
    
    public boolean GetValue()
    {
        boolean value = this.value;
        this.value = false;
        return value;
    }
}
class MenuScene extends Scene
{
    int currentInterface;

    public MenuScene()
    {
        interfaces = new Interface[] {
            new MenuInterface(new Button[] {
                new InterfaceNavButton(this, 1, "Easy"),
                new InterfaceNavButton(this, 2, "Medium"),
                new InterfaceNavButton(this, 3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new Button[] {
                null,
                new InterfaceNavButton(this, 2, "Medium"),
                new InterfaceNavButton(this, 3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new Button[] {
                new InterfaceNavButton(this, 1, "Easy"),
                null,
                new InterfaceNavButton(this, 3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new Button[] {
                new InterfaceNavButton(this, 1, "Easy"),
                new InterfaceNavButton(this, 2, "Medium"),
                null,
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
        };
    }
    
    public void HandleInput(boolean[] inputs) {
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

    public void Draw() {
        background(0);

        // Draw icons
        float aspect = Resources.logoImage.width / Resources.logoImage.height;
        float sizeMax = width * .4f;
        float xPos = width * 0.25f;
        float yPos = height * 0.25f;

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

    public void ChangeInterface(int index)
    {
        currentInterface = index;
    }
}

class MenuInterface extends Interface
{
    Button[] buttons;
    
    public MenuInterface(Button[] buttons)
    {
        this.buttons = buttons;
    }
    
    public void Draw() {
        for (int i = 0; i < buttons.length; i++) {
            if (buttons[i] == null)
                continue;
            buttons[i].Draw(i, buttons.length);
        }
    }

    public void Select(int index)
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
    
    public void Invoke() {
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
    
    public void Invoke() {
        scene.ChangeInterface(targetIndex);
        selected = false;
    }
}
static class Resources
{
    static PImage logoImage;
    static PImage homeImage;
    
    static PFont font;

    static SoundFile confirmSound;
    static SoundFile selectSound;


    public static void Initialise()
    {
        logoImage = BeatBot.instance.loadImage("logo.png");
        homeImage = BeatBot.instance.loadImage("back.png");

        font = BeatBot.instance.createFont("united-kingdom.otf", 1);

        confirmSound = new SoundFile(BeatBot.instance, "confirm.wav");
        selectSound = new SoundFile(BeatBot.instance, "back.wav");
    }
}
static class SceneManager
{
    static int currentSceneIndex;   
    static Scene[] scenes;
    
    public static void Initialise()
    {
        currentSceneIndex = 0;
        scenes = new Scene[] {
            BeatBot.instance.new MenuScene()
        };
    }
    
    public static void Draw()
    {
        Scene activeScene = ActiveScene();

        if (activeScene == null)
            return;
            
        activeScene.Draw();
    }
    
    public static void Load(int index)
    {
        if (index < 0 || index >= scenes.length)
            return;
            
        currentSceneIndex = index;
    }

    public static void HandleInput(boolean[] inputs)
    {
        Scene activeScene = ActiveScene();

        if (activeScene == null)
            return;

        activeScene.HandleInput(inputs);
    }

    public static Scene ActiveScene()
    {
        return scenes.length == 0 ? null : scenes[currentSceneIndex];
    }
}

abstract class Scene
{
    Interface[] interfaces;
    public abstract void HandleInput(boolean[] inputs);
    public abstract void Draw();
    public abstract void ChangeInterface(int index);
}
abstract class Interface
{
    public abstract void Draw();
    public abstract void Select(int index);
}

abstract class Button
{
    boolean selected;

    final float buttonAngle = -PI * 0.22f;

    public abstract void Invoke();

    public void Select() {
        if (selected) {
            Invoke();
            selected = false;
            Resources.confirmSound.play();
            return;
        }

        selected = true;
        Resources.selectSound.play();
    }
    
    public void Deselect() {
        selected = false;
    }

    public float CalculateButtonWidth(int totalButtons)
    {
        return (CalculateTotalWidth() / totalButtons) * sin(-buttonAngle);
    }

    public float CalculateTotalWidth()
    {
        return (float) height / (tan(-buttonAngle));
    }

    public float CalculateRectLength(int buttonIndex, int totalButtons)
    {
        return ((height / (float) totalButtons) * (totalButtons - buttonIndex)) / (sin(-buttonAngle));
    }

    public void Draw(int buttonIndex, int totalButtons)
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

    public void PushMatrix(int buttonIndex, int totalButtons)
    {
        pushMatrix();

        float totalWidth = CalculateTotalWidth();

        translate(width - totalWidth + (totalWidth / (float) totalButtons) * buttonIndex, height);
        rotate(buttonAngle);
    }

    public void SetColour(int buttonIndex)
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

class LabelButton extends Button
{
    String label;


    LabelButton() {}

    LabelButton(String label)
    {
        this.label = label;
    }


    public void Invoke() {}

    public @Override
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


    public void Invoke() {}

    public @Override
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
    public void settings() {  size(800, 600); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "BeatBot" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
