static class Resources
{
    static PImage logoImage;
    static PImage homeImage;
    
    static PFont font;

    static SoundFile confirmSound;
    static SoundFile retreatSound;


    static void Initialise()
    {
        logoImage = BeatBot.instance.loadImage("logo.png");
        homeImage = BeatBot.instance.loadImage("back.png");

        font = BeatBot.instance.createFont("united-kingdom.otf", 1);

        confirmSound = new SoundFile(BeatBot.instance, "confirm.wav");
        retreatSound = new SoundFile(BeatBot.instance, "back.wav");
    }
}