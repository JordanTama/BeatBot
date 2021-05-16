static class SceneManager
{
    static int currentSceneIndex;   
    static Scene[] scenes;
    
    static void Initialise()
    {
        currentSceneIndex = 0;
        scenes = new Scene[] {
            BeatBot.instance.new MenuScene(),
            BeatBot.instance.new GameScene()
        };
    }
    
    static void Draw()
    {
        Scene activeScene = ActiveScene();

        if (activeScene == null)
            return;
            
        activeScene.Draw();
    }
    
    static void Load(int index)
    {
        if (index < 0 || index >= scenes.length)
            return;
            
        currentSceneIndex = index;

        Scene activeScene = ActiveScene();
        if (activeScene != null)
            activeScene.OnLoad();
    }

    static void HandleInput(boolean[] inputs)
    {
        Scene activeScene = ActiveScene();

        if (activeScene == null)
            return;

        activeScene.HandleInput(inputs);
    }

    static Scene ActiveScene()
    {
        return scenes.length == 0 ? null : scenes[currentSceneIndex];
    }
}

abstract class Scene
{
    Interface[] interfaces;
    int currentInterface;
    
    abstract void HandleInput(boolean[] inputs);
    abstract void Draw();
    
    void ChangeInterface(int index) {
        currentInterface = index;
    }

    void OnLoad() {}
}
