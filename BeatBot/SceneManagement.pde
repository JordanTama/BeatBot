static class SceneManager
{
    static BeatBot program;
    static int currentSceneIndex;
    
    static Scene[] scenes;
    
    static void Initialise(BeatBot sketch, Scene[] sketchScenes)
    {
        program = sketch;
        currentSceneIndex = 0;
        scenes = sketchScenes;
    }
    
    static void Draw()
    {
        if (scenes.length == 0)
            return;
            
        scenes[currentSceneIndex].Draw();
    }
    
    static void Load(int index)
    {
        if (index < 0 || index >= scenes.length)
            return;
            
        currentSceneIndex = index;
    }
}

abstract class Scene
{
    abstract void HandleInput(boolean[] inputs);
    abstract void Draw();
}
