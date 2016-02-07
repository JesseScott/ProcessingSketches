class KinectTracker {

  // Size of kinect image
  int kw = 640;
  int kh = 480;
  int threshold = kThresh;

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;


  PImage display;

  KinectTracker() {
    kinect.start();
    kinect.enableDepth(true);

    // We could skip processing the grayscale image for efficiency
    // but this example is just demonstrating everything
    kinect.processDepthImage(true);

    display = createImage(kw,kh,PConstants.RGB);

    loc = new PVector(0,0);
    lerpedLoc = new PVector(0,0);
  
    
  }

  void track() {

    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for(int x = 0; x < kw; x++) {
      for(int y = 0; y < kh; y++) {
        // Mirroring the image
        //int offset = kw-x-1+y*kw;
        int offset = x + y*kw;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      loc = new PVector(sumX/count,sumY/count);
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    //canvas.beginDraw();
    PImage img = kinect.getDepthImage();
    canvas.smooth();
    //canvas.hint(ENABLE_OPENGL_4X_SMOOTH);
    //canvas.glEnable(canvas.GL_POINT_SMOOTH);
    canvas.pushMatrix();
    canvas.scale(1.5);
    // Being overly cautious here
    if (depth == null || img == null) return;

    // IMAGE
    if(pts == false) {
      display.loadPixels();
      for(int x = 0; x < kw; x++) {
        for(int y = 0; y < kh; y++) {
          // mirroring image
          int offset = kw-x-1+y*kw;
          // Raw depth
          int rawDepth = depth[offset];
          int pix = x+y*display.width;
          if (rawDepth < threshold) {
            //float fade = map(rawDepth, 0, 1000, 0, 255);
            display.pixels[pix] = color(blobColor);      
          } 
          else {
            // display.pixels[pix] = img.pixels[offset];
            // display.pixels[pix] = img.pixels[0];
          }
        }
      }
      display.updatePixels();
    }
    // POINTS
    else if(pts == true) {
      
      
    }

    // bD
    theBlobDetection.computeBlobs(display.pixels);
    theBlobDetection.setThreshold(bThresh);
    
    if(touch == 1) {
        canvas.translate(width/4, height/4, -10);
        //canvas.rotateX(rx);
        //canvas.rotateY(rx);
        //canvas.scale(1.1);
        canvas.translate(0-width/4, 0-height/4);
    }
    else if(touch == 0) {
      //canvas.rotateX(0);
      //canvas.rotateY(0);      
      
    }
    blobColor = color(blobR, blobG, blobB, blobA);
    strokeColor = color(strokeR, strokeG, strokeB, strokeA);
    if (drawBlur == true) {
      fastblur(display, blurAmt);
    }
    
    if (drawImg == true) {
      canvas.image(display, 0, 0); 
    }

    if (drawBlob == true) {
      drawBlobsAndEdges(false, true);  
    }
    
    canvas.popMatrix();
    //canvas.endDraw();
  }
  
  void erase() {
    
    color c = color(0,0);
      display.loadPixels();
      for (int x=0; x<display.width; x++) {
        for (int y=0; y<display.height; y++ ) {
          int loc = x + y*display.width;
          display.pixels[loc] = c;
        }
      }
      display.updatePixels();
      
      canvas.beginDraw();
        canvas.clear(0,0,0,0);
      canvas.endDraw();
  }

  void quit() {
    kinect.quit();
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  kThresh;
  }
}

