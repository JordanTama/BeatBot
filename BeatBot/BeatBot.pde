// Libraries //<>//
import processing.serial.*;
import processing.sound.*;


// Member variables
static Controller controller;

final boolean keyboardOverride = false;

State state; // temporary


// Event functions
void setup()
{
    size(800, 600);
    
    controller = new Controller(this);

    state = new State(this);
    CreateMenus();
    
    SceneManager.Initialise(this, new Scene[] {});
}

void draw()
{
    HandleInput();
    SceneManager.Draw();
    
    state.currentMenu.Draw();
}

void keyPressed()
{
    if (keyboardOverride)
        controller.Update();
    else
        return;
    
    switch (key)
    {
        case '7':
            controller.Override(0);
            break;
            
        case '8':
            controller.Override(1);
            break;
            
        case '9':
            controller.Override(2);
            break;
            
        case '0':
            controller.Override(3);
            break;
    }
}


// Functions
void HandleInput()
{
    if (!keyboardOverride)
        controller.Update();

    boolean[] inputs = controller.GetValues();
    
    for (int i = 0; i < inputs.length; i++)
    {
        if (!inputs[i])
            continue;
        
        //SceneManager.Load(i);
        state.currentMenu.Select(i);
        return;
    }
}

void CreateMenus()
{
    state = new State(this);
    
    Menu mainMenu = new Menu(state, "Main Menu");
    Menu easyMenu = new Menu(state, "Easy");
    Menu mediumMenu = new Menu(state, "Medium");
    Menu hardMenu = new Menu(state, "Hard");
    
    
    Button[] mainButtons = {
        new Button(easyMenu, "EASY"),
        new Button(mediumMenu, "MEDIUM"),
        new Button(hardMenu, "HARD"),
        new Button(mainMenu, "")
    };
    mainMenu.SetButtons(mainButtons);
    
    Button[] easyButtons = {
        new Button(mediumMenu, "MEDIUM"),
        new Button(hardMenu, "HARD"),
        null,
        new Button(mainMenu, "")
    };
    easyMenu.SetButtons(easyButtons);
    
    Button[] mediumButtons = {
        new Button(easyMenu, "EASY"),
        new Button(hardMenu, "HARD"),
        null,
        new Button(mainMenu, "")
    };
    mediumMenu.SetButtons(mediumButtons);
    
    Button[] hardButtons = {
        new Button(easyMenu, "EASY"),
        new Button(mediumMenu, "MEDIUM"),
        null,
        new Button(mainMenu, "")
    };
    hardMenu.SetButtons(hardButtons);
    
    state.Start(mainMenu);
}
