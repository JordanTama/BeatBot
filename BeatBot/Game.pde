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
    void OnLoad() {
        track = Resources.GetTrack(difficultyIndex);

        time = 0;
        startTime = millis();

        beatTime = -buffer * 2;
        beatTotal = (track.duration() / 60.0 * bpm) + beatTime;

        CreateNotes();

        track.play(1, 0, 0.1);
    }

    void HandleInput(boolean[] inputs) {
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

    void Draw() {
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
    void CreateNotes() {
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

    float RandomOffsetEasy() {
        int rand = (int) random(0, 4);
        switch (rand) {
            case 0:
                return 1;

            case 1:
                return 1.5;
            
            case 2:
                return 2;
            
            case 3:
                return 2.5;
            
            default:
                return 3;
        }
    }

    float RandomOffsetMedium() {
        int rand = (int) random(0, 4);
        switch (rand) {
            case 0:
                return 0.5;

            case 1:
                return 1;
            
            case 2:
                return 1.5;
            
            case 3:
                return 2;
            
            default:
                return 3;
        }
    }

    float RandomOffsetHard() {
        int rand = (int) random(0, 4);
        switch (rand) {
            case 0:
                return 0.25;

            case 1:
                return 0.5;
            
            case 2:
                return 1;
            
            case 3:
                return 1.5;
            
            default:
                return 2;
        }
    }

    void UpdateActive() {
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

    void DrawNote(Note note) {
        PImage img = Resources.GetNote(note.inputIndex);

        float x = (width - laneWidth * 3) / 2 + note.inputIndex * laneWidth;
        float y = map(note.triggered ? note.triggerStart : beatTime, note.beat - buffer, note.beat, startHeight, endHeight);

        imageMode(CENTER);
        tint(255, 255, 255, note.triggered ? map(beatTime, note.triggerStart, note.triggerStart + note.triggerDuration, 255, 0) : 255);
        image(img, x, y, 70, 70);
    }

    void DrawLane(int laneIndex) {
        Resources.SetColour(laneIndex);
        
        imageMode(CENTER);
        noStroke();

        float x = (width - laneWidth * 3) / 2 + laneIndex * laneWidth;
        float y = height / 2;

        image(Resources.laneImage, x, y, laneWidth, height);
    }

    void DrawEndLine() {
        
        strokeWeight(5);
        int x = 0;
        while (x < width) {
            stroke(255);
            line(x, endHeight, x += 15, endHeight);
            noStroke();
            line(x, endHeight, x += 10, endHeight);
        }
    }

    void DrawText() {
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

    float HandleTimer() {
        float currentTime = millis() - startTime;
        float delta = (currentTime - time) / 60000 * bpm;
        time = currentTime;

        beatTime += delta;

        return delta;
    }

    void EndGame() {
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