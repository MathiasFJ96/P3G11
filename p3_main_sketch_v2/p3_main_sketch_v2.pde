import blobDetection.*;
import KinectPV2.*;
import processing.sound.*;

//import oscP5.*;


SoundFile file;
float amp;
float rate;


KinectPV2 kinect;
BlobDetection BlobDetection;

//OscP5 oscP5;

float distanceThreshold, colorThreshold;

PImage display, depthImage;
int depth[];
int widthOfWindow, heightOfWindow;
void setup() {
  size(512, 424);
  widthOfWindow = 512;
  heightOfWindow = 424;
  //oscP5 = new OscP5(this,12000);
  //pureData = new NetAddress("localhost",8000);

  //kinect
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.init();

  //blob detection
  BlobDetection = new BlobDetection(512, 424);
  BlobDetection.setPosDiscrimination(false);
  BlobDetection.setThreshold(1f);
  
  //sound
  file = new SoundFile(this, "sound.wav");
  file.loop();
}

void draw() {
  depth = kinect.getRawDepthData();
  depthImage = kinect.getDepthImage();



  // Being overly cautious here
  if (depth == null && depthImage == null) {
    return;
  }
  // threshold min max  kinect width kinect height
  Threshold(500, 2000, 512, 424);

  //image(display, 0, 0, 1024, 848);

  PImage BlobImage = display;


  pushMatrix();
  translate(0, 0);

  BlobDetection.computeBlobs(BlobImage.pixels);

  image(display, 0, 0, widthOfWindow, heightOfWindow);
  drawBlobsAndEdges(true);

  popMatrix();
  
}

void mouseClicked() {
  float i = mouseX + mouseY*widthOfWindow;
  float i2 = map(i,0, 868, 0, 217);
  
  println(depth[int(i2)]);
  int j = depth[int(i2)];
  print("Meter away from camera: " + depthLookUpTable(j));
}



public void Threshold(int threshold_min, int threshold_max, int kw, int kh) {
  display = createImage(kw, kh, RGB);
  //display.loadPixels();

  for (int x = 1; x < kw-1; x++) {

    for (int y = 1; y <kh-1; y++) {

      int index = x + y * kw;
      if (depth[index] > threshold_min && depth[index] < threshold_max) {
        // A red color instead
        display.pixels[index] = color(255, 255, 255);
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

void drawBlobsAndEdges(boolean drawBlobs)
{
  noFill();
  ArrayList<Blob> blobs = new ArrayList<Blob>();
  for (int n = 0; n < BlobDetection.getBlobNb(); n++)
  {
    blobs.add(BlobDetection.getBlob(n));
  }

  Blob biggestBlob = null;
  ArrayList<Blob> blobsOfSize = arrayListofBlobs(blobs, 20000);

  if (blobsOfSize != null) {
    for (Blob b : blobsOfSize) {
      biggestBlob = biggestblob(b);
    }
  }

  if (biggestBlob != null) {
    // Blobs
    if (drawBlobs)
    {
      strokeWeight(4);
      stroke(255, 0, 0);
      rect(biggestBlob.xMin*widthOfWindow, biggestBlob.yMin*heightOfWindow, biggestBlob.w*widthOfWindow, biggestBlob.h*heightOfWindow);
      soundOnCondition(biggestBlob.w*widthOfWindow,biggestBlob.h*heightOfWindow);
  }
  }
}

ArrayList<Blob> arrayListofBlobs(ArrayList<Blob> blobs_, int size) {
  ArrayList<Blob> blobsOfSize = new ArrayList<Blob>();
  if (blobs_ != null) {
    for (Blob b : blobs_) {
      float area = ((b.w*512) * (b.h*424));
      if (area > size) {
        blobsOfSize.add(b);
      }
    }
  }
  return blobsOfSize;
}

Blob biggestblob(Blob b) {
  Blob BiggestBlob;
  float blobarea = ((b.w*512) * (b.h*424));
  float temparea = 2000000000;
  if (temparea > blobarea) {
    
    temparea = blobarea;
    BiggestBlob = b;
    return BiggestBlob;
  }
  return null;
}

void soundOnCondition(float widthOfBlob,float heightOfBlob){
  //float widthofk = map(widthOfBlob, 0,1024,0,512);
  //float heightofk = map(heightOfBlob,0,848,0,424);
  
  float m1 = map(heightOfBlob, 150, 450, 0, 1);
  amp = m1;
  float m2 = map(widthOfBlob, 0, 424, 0.1f, 3.5f);
  rate = m2;
  
  delay(100);
  file.amp(amp);
  file.rate(rate);
  delay(100);
}
