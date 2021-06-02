static class Resources
{
    static PImage logoImage;
    static PImage homeImage;
    static PImage laneImage;
    static PImage volumeUpImage;
    static PImage volumeDownImage;
    static PImage playImage;

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


    static void Initialise()
    {
        logoImage = BeatBot.instance.loadImage("logo.png");
        homeImage = BeatBot.instance.loadImage("back.png");
        laneImage = BeatBot.instance.loadImage("lane.png");
        volumeUpImage = BeatBot.instance.loadImage("volumeUp.png");
        volumeDownImage = BeatBot.instance.loadImage("volumeDown.png");
        playImage = BeatBot.instance.loadImage("play.png");

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

    static SoundFile GetTrack(int trackIndex) {
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

    static PImage GetNote(int noteIndex) {
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

    static void SetColour(int buttonIndex) {
        switch (buttonIndex)
        {
            case 0:
                BeatBot.instance.fill(37, 255, 195, 255);
                BeatBot.instance.tint(37, 255, 195, 255);
                BeatBot.instance.stroke(37, 255, 195, 255);
                break;
                
            case 1:
                BeatBot.instance.fill(14, 20, 252, 255);
                BeatBot.instance.tint(14, 20, 252, 255);
                BeatBot.instance.stroke(14, 20, 252, 255);
                break;
                
            case 2:
                BeatBot.instance.fill(236, 62, 200, 255);
                BeatBot.instance.tint(236, 62, 200, 255);
                BeatBot.instance.stroke(236, 62, 200, 255);
                break;
                
            case 3:
                BeatBot.instance.fill(114, 8, 188, 255);
                BeatBot.instance.tint(114, 8, 188, 255);
                BeatBot.instance.stroke(114, 8, 188, 255);
                break;
            
            default:
                BeatBot.instance.fill(255);
                BeatBot.instance.tint(255);
                BeatBot.instance.stroke(255);
                break;
        };
    }
}