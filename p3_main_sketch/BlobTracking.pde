class BlobTracking {

  ArrayList<Blob> blobs = new ArrayList<Blob>();


  BlobTracking() {
  }

  void tracking(PImage image) {

    
    image.updatePixels();

    blobs.clear();
    
    //look through all the pixels and the if statement are only true with red pixels.
    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        // What is current color
        int index = x + y * image.width;
        color currentColor = image.pixels[index];
        //println(red(currentColor));
        if (compareRedColor(red(currentColor))) {

          boolean isFound = false;
          for (Blob b : blobs) {
            if (b.neighborhood(x, y)) {
              b.add(x, y);
              isFound = true;
              break;
            }
          }

          if (!isFound) {
            Blob b = new Blob(x, y);
            blobs.add(b);
          }
        }
      }
    }
  }// end bracket method

  void displayOnCondition() {
    //loop through the blobs and check the condition and display those who met it.
    for (Blob b : tracker.blobs) {
      if (b.sizeOfBlob() > 750) {
        b.display();
      }
    }
  }// end bracket method

  boolean compareRedColor(float tempColor) {
    //simple color comparer taht returns true if the color are red
    float track = red(trackColor);
    if (tempColor == track) {
      return true;
    } else {
      return false;
    }
  }// end bracket method
  
  
}// end bracket class
