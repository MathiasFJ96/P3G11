import KinectPV2.*;
//import oscP5.*;
//import netP5.*;

KinectPV2 kinect;
BlobTracking tracker;

//NetAddress pureData;
//OscP5 oscP5;

float distanceThreshold, colorThreshold;

PImage display, depthImage;
int depth[];
color trackColor;

//int savedTime;
//int totalTime;

void setup() {
  size(1024, 424);
  
  //oscP5 = new OscP5(this,12000);
  //pureData = new NetAddress("localhost",8000);
  
  tracker = new BlobTracking();
  kinect = new KinectPV2(this);
  //savedTime = millis();
  //totalTime = 5000;

  kinect.enableDepthImg(true);
  kinect.init();
  trackColor = color(255, 0, 0);
}

void draw() {
  depth = kinect.getRawDepthData();
  depthImage = kinect.getDepthImage();

  // Being overly cautious here
  if (depth == null && depthImage == null) {
    return;
  }
  // threshold min max  kinect width kinect height
  Threshold(1000, 2000, 512, 424);


  image(display, 0, 0, 512, 424);
  
  
  
  //PImage blobtrackingImage = display.copy();

  
  //image(blobtrackingImage, 512, 0, 512, 424);
  PImage grayImage = createImage(512,424, RGB);
  image(grayImage,512, 0, 512, 424);
  
  if(true){
  tracker.tracking(display);
 
  } 
  
  if (tracker.blobs != null){
    tracker.displayOnCondition();
  }
  
  
  frameRate();
  
}

void mouseClicked() {
  int i = mouseX + mouseY*512;
  println(depth[i]);
  int j = depth[i];
  print("Meter away from camera: " + depthLookUpTable(j));
}

/*public boolean timer(){
  int passedTime = millis() - savedTime;
  if (passedTime > totalTime) {
    savedTime = millis();
    return true;
  } else {
    return false;
  }
}
*/
public void frameRate(){
  //text("Frame Rate: " + int(frameRate), 25, 25);
  println(frameRate);
}

public void Threshold(int threshold_min, int threshold_max, int kw, int kh) {
  display = createImage(kw, kh, RGB);
  //display.loadPixels();

  for (int x = 0; x < kw; x++) {

    for (int y = 0; y <kh; y++) {

      int index = x + y * kw;
      if (depth[index] > threshold_min && depth[index] < threshold_max) {
        // A red color instead
        display.pixels[index] = color(255, 0, 0);
      } else {
        display.pixels[index] = color(0, 0, 0);
      }
    }
  }
  //display.updatePixels();
}

public float depthLookUpTable(int index) {
  float[] depthLookUp = new float[5500];
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
  return depthLookUp[index];
}

public float rawDepthToMeters(int depthValue) {
  if (depthValue < 5499) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

public float distBetween(float x1, float y1, float x2, float y2) {
  //mangler kvadratrod 
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}
