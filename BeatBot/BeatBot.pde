// LIBRARIES
import processing.serial.*;
import processing.sound.*;


// MEMBER VARIABLES
static Controller controller;
static BeatBot instance;


// EVENT FUNCTIONS
void setup()
{
    instance = this;

    Resources.Initialise();
    SceneManager.Initialise();

    controller = new Controller();

    size(800, 600);
}

void draw()
{
    HandleInput();
    SceneManager.Draw();
}

void keyPressed()
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

void keyReleased()
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
void HandleInput()
{
    boolean[] inputs = controller.GetValues();
    SceneManager.HandleInput(inputs);

    controller.Update();
}
