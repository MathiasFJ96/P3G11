import processing.sound.*;

SoundFile files;

// Create an array of values which represent the octaves. 
// 1.0 is playback at normal speed, 0.5 is half and therefore 
// one octave down. 2.0 is double so one octave up.
float octave = 2;
  //0.25, 0.5, 1.0, 2.0, 4.0
//};

// The playSound array is defining how many samples will be 
// played at each trigger event
int playSound = 1; 
  //1, 1, 1, 1, 1
//};

// The trigger is an integer number in milliseconds so we 
// can schedule new events in the draw loop
int trigger=0;

// This array holds the pixel positions of the rectangles 
// that are drawn each event
int posx = 128;
  //0, 128, 256, 384, 512


void setup() {
  size(640, 360);
  background(255);

  // Create an array of 5 empty soundfiles
  files = new SoundFile(this, "sound.wav");

  // Load 5 soundfiles from a folder in a for loop. By naming 
  // the files 1., 2., 3., [...], n.aif it is easy to iterate 
  // through the folder and load all files in one line of code.
  //for (int i = 0; i < files.length; i++) {
    //files[i] = new SoundFile(this, (i+1) + ".aif");
  //}
}

void draw() {

  // If the determined trigger moment in time matches up with 
  // the computer clock events get triggered.
  if (millis() > trigger) {

    // Redraw the background every time to erase old rects
    background(255);

    // By iterating through the playSound array we check for 
    // 1 or 0, 1 plays a sound and draws a rect, for 0 nothing happens

//for (int i = 0; i < files.length; i++) {      
      // Check which indexes are 1 and 0.
      if (playSound == 1) {
        float rate;
        // Choose a random color and get set to noStroke()
        fill(int(random(255)), int(random(255)), int(random(255)));
        noStroke();
        // Draw the rect in the positions we defined earlier in posx
        rect(posx, 50, 128, 260);
        // Choose a random index of the octave array
        //rate = octaveint(random(0, 5)); //<--- wut is dis
        rate = octave;
        // Play the soundfile from the array with the respective 
        // rate and loop set to false
        files.play(rate, 1.0);
      }

      // Renew the indexes of playSound so that at the next event 
      // the order is different and randomized.
      playSound = int(random(0, 2));
    }

    // Create a new triggertime in the future, with a random offset 
    // between 200 and 1000 milliseconds
    trigger = millis() + int(random(200, 1000));
  }
//}
