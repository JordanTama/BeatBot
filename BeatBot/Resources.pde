static class Resources
{
    static PImage homeImage;

    static void Initialise()
    {
        homeImage = BeatBot.instance.loadImage("back.png");
    }
}