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
class GameScene extends Scene
{
    // Member variables
    SoundFile track;

    float startTime;
    float time;

    float beatTime;
    float beatTotal;

    int difficultyIndex;
    
    float bpm;

    int missed = 0;
    float score = 0;
    float buffer = 4;
    float lenience = 1;

    float laneWidth = 110;
    float startHeight = -100;
    float endHeight = height - 200;

    ArrayList<Note> notes = new ArrayList<Note>();
    ArrayList<Note> activeNotes = new ArrayList<Note>();


    GameScene(int difficultyIndex, int bpm) {
        this.difficultyIndex = difficultyIndex;
        this.bpm = bpm;
    }


    // Event functions
    public void OnLoad() {
        track = Resources.GetTrack(difficultyIndex);

        time = 0;
        startTime = millis();

        beatTime = -buffer * 2;
        beatTotal = (track.duration() / 60.0f * bpm) + beatTime;

        CreateNotes();

        track.play(1, 0, 0.1f);
    }

    public void HandleInput(boolean[] inputs) {
        for (int i = 0; i < inputs.length; i++)
        {
            if (!inputs[i])
                continue;
            
            for (Note note : activeNotes)
            {
                if (note.inputIndex == i && abs(note.beat - beatTime) < lenience && !note.triggered)
                {
                    note.Trigger(beatTime);
                    score ++;
                    missed = 0;
                    break;
                }
            }
        }
    }

    public void Draw() {
        HandleTimer();

        // Spawn in notes
        UpdateActive();

        // Draw the background
        background(0);
        for (int i = 0; i < 4; i++)
            DrawLane(i);

        // Draw the Notes
        for (Note note : activeNotes)
            DrawNote(note);

        // Draw the UI
        DrawEndLine();
        DrawText();

        if (beatTime > beatTotal + buffer || missed >= 10)
            EndGame();
    }

    // Functions
    public void CreateNotes() {
        // TODO: Go through the .dat file and convert to Notes.

        float pos = 0;

        while (pos <= beatTotal) {
            float t = pos;

            switch (difficultyIndex) {
                case 0:
                    t += RandomOffsetEasy();
                    break;

                case 1:
                    t += RandomOffsetMedium();
                    break;
                
                default:
                    t += RandomOffsetHard();
                    break;
            }
            pos = t;

            int index = (int) random(0, 4);

            notes.add(new Note(index, pos, 0));
        }
    }

    public float RandomOffsetEasy() {
        int rand = (int) random(0, 4);
        switch (rand) {
            case 0:
                return 1;

            case 1:
                return 1.5f;
            
            case 2:
                return 2;
            
            case 3:
                return 2.5f;
            
            default:
                return 3;
        }
    }

    public float RandomOffsetMedium() {
        int rand = (int) random(0, 4);
        switch (rand) {
            case 0:
                return 0.5f;

            case 1:
                return 1;
            
            case 2:
                return 1.5f;
            
            case 3:
                return 2;
            
            default:
                return 3;
        }
    }

    public float RandomOffsetHard() {
        int rand = (int) random(0, 4);
        switch (rand) {
            case 0:
                return 0.25f;

            case 1:
                return 0.5f;
            
            case 2:
                return 1;
            
            case 3:
                return 1.5f;
            
            default:
                return 2;
        }
    }

    public void UpdateActive() {
        for (int i = activeNotes.size() - 1; i >= 0; i--)
        {
            Note note = activeNotes.get(i);
            if (note.triggered && note.triggerStart + note.triggerDuration < beatTime)
            {
                activeNotes.remove(i);
            }
            else if (note.beat + buffer < beatTime)
            {
                activeNotes.remove(i);
                missed++;
            }
        }

        for (Note note : notes)
        {
            if (beatTime + buffer < note.beat)
                break;
            
            activeNotes.add(note);
        }

        for (int i = notes.size() - 1; i >= 0; i--)
        {
            if (activeNotes.contains(notes.get(i)))
                notes.remove(i);
        }
    }

    public void DrawNote(Note note) {
        PImage img = Resources.GetNote(note.inputIndex);

        float x = (width - laneWidth * 3) / 2 + note.inputIndex * laneWidth;
        float y = map(note.triggered ? note.triggerStart : beatTime, note.beat - buffer, note.beat, startHeight, endHeight);

        imageMode(CENTER);
        tint(255, 255, 255, note.triggered ? map(beatTime, note.triggerStart, note.triggerStart + note.triggerDuration, 255, 0) : 255);
        image(img, x, y, 70, 70);
    }

    public void DrawLane(int laneIndex) {
        Resources.SetColour(laneIndex);
        
        imageMode(CENTER);
        noStroke();

        float x = (width - laneWidth * 3) / 2 + laneIndex * laneWidth;
        float y = height / 2;

        image(Resources.laneImage, x, y, laneWidth, height);
    }

    public void DrawEndLine() {
        
        strokeWeight(5);
        int x = 0;
        while (x < width) {
            stroke(255);
            line(x, endHeight, x += 15, endHeight);
            noStroke();
            line(x, endHeight, x += 10, endHeight);
        }
    }

    public void DrawText() {
        float x = width - (width - laneWidth * 4) / 4;
        float y = 30;

        rectMode(CENTER);
        textAlign(CENTER);
        textSize(18);

        fill(255);
        text("Score", x, y, 100, 30);
        y += 30;

        fill(236, 62, 200, 255);
        text("" + ((int) score), x, y, 100, 30);

        String difficultyLabel = "";
        switch (difficultyIndex) {
            case 0:
                difficultyLabel = "easy";
                break;

            case 1:
                difficultyLabel = "medium";
                break;

            case 2:
                difficultyLabel = "hard";
                break;
        }

        x = (width - laneWidth * 4) / 4;
        y = 30;

        fill(255);
        text("Level", x, y, 100, 30);
        y += 30;

        fill(236, 62, 200, 255);
        text(difficultyLabel, x, y, 100, 30);
    }

    public float HandleTimer() {
        float currentTime = millis() - startTime;
        float delta = (currentTime - time) / 60000 * bpm;
        time = currentTime;

        beatTime += delta;

        return delta;
    }

    public void EndGame() {
        println("End game");
        track.stop();
        SceneManager.Load(0);
    }
}

class Note
{
    int inputIndex;

    float beat;
    float duration;

    boolean triggered = false;
    float triggerStart = 0;

    final float triggerDuration = 1;

    public Note(int inputIndex, float beat, float duration)
    {
        this.inputIndex = inputIndex;
        this.beat = beat;
        this.duration = duration;
    }

    public void Trigger(float beatTime) {
        if (triggered)
            return;
        
        triggered = true;
        triggerStart = beatTime;
        Resources.selectSound.play();
    }
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
            values[i] = controls[i].GetValue();
            
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
    public MenuScene()
    {
        interfaces = new Interface[] {
            new MenuInterface(new Button[] {
                new InterfaceNavButton(this, 1, "Play"),
                new InterfaceNavButton(this, 2, "Options"),
                new InterfaceNavButton(this, 3, "Help"),
                null
            }),
            new MenuInterface(new Button[] {
                new SceneNavButton(1, "Easy"),
                new SceneNavButton(2, "Medium"),
                new SceneNavButton(3, "Hard"),
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new Button[] {
                null,
                null,
                null,
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
            new MenuInterface(new Button[] {
                null,
                null,
                null,
                new InterfaceNavImageButton(this, 0, Resources.homeImage)
            }),
        };
    }

    public void OnLoad() {
        Resources.menuTrack.loop(1, 0.01f);
    }

    public void OnUnload() {
        Resources.menuTrack.stop();
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

class SceneNavButton extends LabelButton
{
    int targetIndex;

    SceneNavButton(int targetIndex, String label)
    {
        super(label);

        this.targetIndex = targetIndex;
    }
    
    public void Invoke() {
        SceneManager.Load(targetIndex);
        selected = false;
    }
}
static class Resources
{
    static PImage logoImage;
    static PImage homeImage;
    static PImage laneImage;

    static PImage aNote;
    static PImage bNote;
    static PImage cNote;
    static PImage dNote;
    
    static PFont font;

    static SoundFile confirmSound;
    static SoundFile selectSound;

    static SoundFile menuTrack;

    static SoundFile easyTrack;
    static SoundFile mediumTrack;
    static SoundFile hardTrack;


    public static void Initialise()
    {
        logoImage = BeatBot.instance.loadImage("logo.png");
        homeImage = BeatBot.instance.loadImage("back.png");
        laneImage = BeatBot.instance.loadImage("lane.png");

        aNote = BeatBot.instance.loadImage("aNote.png");
        bNote = BeatBot.instance.loadImage("bNote.png");
        cNote = BeatBot.instance.loadImage("cNote.png");
        dNote = BeatBot.instance.loadImage("dNote.png");

        font = BeatBot.instance.createFont("united-kingdom.otf", 1);

        confirmSound = new SoundFile(BeatBot.instance, "confirm.wav");
        selectSound = new SoundFile(BeatBot.instance, "back.wav");

        menuTrack = new SoundFile(BeatBot.instance, "menuTrack.wav");

        easyTrack = new SoundFile(BeatBot.instance, "easyTrack.wav");
        mediumTrack = new SoundFile(BeatBot.instance, "mediumTrack.wav");
        hardTrack = new SoundFile(BeatBot.instance, "hardTrack.wav");
    }

    public static SoundFile GetTrack(int trackIndex) {
        switch (trackIndex) {
            case 0:
                return easyTrack;
            
            case 1:
                return mediumTrack;
            
            case 2:
                return hardTrack;

            default:
                return null;
        }
    }

    public static PImage GetNote(int noteIndex) {
        switch (noteIndex)
        {
            case 0:
                return aNote;
            
            case 1:
                return bNote;

            case 2:
                return cNote;

            case 3:
                return dNote;
            
            default:
                return null;
        }
    }

    public static void SetColour(int buttonIndex) {
        switch (buttonIndex)
        {
            case 0:
                BeatBot.instance.fill(37, 255, 195, 255);
                BeatBot.instance.tint(37, 255, 195, 255);
                break;
                
            case 1:
                BeatBot.instance.fill(14, 20, 252, 255);
                BeatBot.instance.tint(14, 20, 252, 255);
                break;
                
            case 2:
                BeatBot.instance.fill(236, 62, 200, 255);
                BeatBot.instance.tint(236, 62, 200, 255);
                break;
                
            case 3:
                BeatBot.instance.fill(114, 8, 188, 255);
                BeatBot.instance.tint(114, 8, 188, 255);
                break;
            
            default:
                BeatBot.instance.fill(255);
                BeatBot.instance.tint(255);
                break;
        };
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
            BeatBot.instance.new MenuScene(),
            BeatBot.instance.new GameScene(0, 90),
            BeatBot.instance.new GameScene(1, 90),
            BeatBot.instance.new GameScene(2, 90)
        };

        Load(0);
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
        
        scenes[currentSceneIndex].OnUnload();

        currentSceneIndex = index;

        Scene activeScene = ActiveScene();
        if (activeScene != null)
            activeScene.OnLoad();
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
    int currentInterface;
    
    public abstract void HandleInput(boolean[] inputs);
    public abstract void Draw();
    
    public void ChangeInterface(int index) {
        currentInterface = index;
    }

    public void OnLoad() {}

    public void OnUnload() {}
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

        rectMode(CORNER);
        strokeWeight(0);
        Resources.SetColour(buttonIndex);

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
