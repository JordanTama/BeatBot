import processing.sound.*; //<>//

State state;
Controller controller;

void setup()
{
    size(800, 600);
    
    CreateMenus();
    
    controller = new Controller();
    controller.Initialize();
}

void draw()
{
    // Once arduino has been integrated, get input with:
    // int input = controller.GetFingerInput();
    
    background(0);
    state.Draw();
}

// Remove this once arduino input has been implemented
void keyPressed()
{
    int inputIndex = -1;
    
    switch (key)
    {
        case '7':
            inputIndex = 0;
            break;
            
        case '8':
            inputIndex = 1;
            break;
            
        case '9':
            inputIndex = 2;
            break;
            
        case '0':
            inputIndex = 3;
            break;
    }
    
    state.currentMenu.Select(inputIndex);
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
