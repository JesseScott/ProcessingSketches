

// SETUP
// -------------------------------- //

void setup() {
  
  // Screen
  size(640, 480);
  background(0);
  smooth();
  ellipseMode(CENTER);
  
  // Kinect
  //context = new SimpleOpenNI(this, RUN_MODE_MULTI_THREADED);
  context = new SimpleOpenNI(this);
  context.setMirror(false);
  if(context.enableDepth() == false) {
    println("Can't Open the Depth Map -- Maybe The Camera Isn't Connected ?!?");
    exit();
    return; 
  }
  context.enableRGB(640,480,30);
  if(context.enableRGB() == false) {
     println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
     exit();
     return;
  }
  context.alternativeViewPointDepthToImage();
  
  // XML
  loadXML();
  
  // Load Crop Positions
  cropPos = loadStrings("cropPositions.txt");
  cropL = int(cropPos[0]);
  cropR = int(cropPos[1]);
  cropT = int(cropPos[2]);
  cropB = int(cropPos[3]);
  if(debugToConsole) {
    println("Left Crop Set To " + cropL);
    println("Right Crop Set To " + cropR);
    println("Top Crop Set To " + cropT);
    println("Bottom Crop Set To " + cropB);
    println();
  }
  
  // Load Poly Positions
  polyPos = loadStrings("polyPositions.txt");
  pv0 = float(polyPos[0]);
  pv1 = float(polyPos[1]);
  pv2 = float(polyPos[2]);
  pv3 = float(polyPos[3]);
  pv4 = float(polyPos[4]);
  pv5 = float(polyPos[5]);
  pv6 = float(polyPos[6]);
  pv7 = float(polyPos[7]);

  // Create Polygon
  poly = new PVector[4];
  poly[0] = new PVector(pv0, pv1);
  poly[1] = new PVector(pv2, pv3);
  poly[2] = new PVector(pv4, pv5);
  poly[3] = new PVector(pv6, pv7);
  
  // Get Path
  pathName = dataPath("");
  if(debugToConsole) {
    println("Data Path Is " + dataPath(""));
    println();
  }
  
  // Circle Array  
  circle = new CircleButton[numButtons];
  circX = new int[numButtons];
  circY = new int[numButtons];
  
  // Load Circle Positions
  if(runCalibration == false) {
    circPos = loadStrings("circlePositions.txt");
    // Parse X Positions
    for(int i = 0; i < circPos.length -1; i+=2) {
      if(i == 0) {
        circX[i] = int(circPos[i]);
      }
      else if(i > 0) {
        int f = i/2;
        circX[f] = int(circPos[i]);
      }
    }   
    // Parse Y Positions
    for(int i = 1; i < circPos.length; i+=2) {
      if(i == 1) {
        int f = i -1;
        circY[f] = int(circPos[i]);
      }
      else if(i > 1) {
        int f = (i -1) /2;
        circY[f] = int(circPos[i]);
      }
    } 
    // Create Circles
    for(int i = 0; i < numButtons; i++) {
      circle[i] = new CircleButton(circX[i], circY[i], sizeButton, buttonColor, highlight, newTimer);   
    }
  }
  
  // Network
  try {
    client = new Client(this, ipAddress, port);
    if(client.active() == true) {
      client.write("Initiating... \n");
    }
  } catch(Exception e) {
    println("Can't Connect To The Server"); 
    e.printStackTrace();
  }
  // Receive data from server
  if (client.available() > 0) {
    String input;
    input = client.readString();
    println("Server Says " + input);
    println();
  }
  
  // Blob Detection
  bd = new BlobDetection(context.depthWidth(), context.depthHeight());
  bd.setPosDiscrimination(true);
  bd.setThreshold(blobThresh);
  
  if(debugToConsole) {
    println("End Of Setup");
    println();
  }
}

// -------------------------------- //


// DRAW
// -------------------------------- //

void draw() {
  // Reset The Background
  background(0);
  
  // Wait For 30 Seconds So Noise Settles
  if(millis() > 30000) {
    appReady = true; 
  }
      
  // Update Kinect Sensor
  context.update();
  
  // Calibrate Mode
  if(runCalibration == true) {
    // Show RGB Image
    image(context.rgbImage(), 0, 0);
    
    stroke(0,255,0);
    line(cropL, cropT, cropL, cropB); // Left Crop 
    line(cropR, cropT, cropR, cropB); // Right Crop
    line(cropL, cropT, cropR, cropT); // Top Crop
    line(cropL, cropB, cropR, cropB); // Bottom Crop
    
  }
  else if(runCalibration == false && appReady == true) {
    // Show The Depth Image
    //image(context.depthImage(), 0, 0);
    
    // Update Blob Detection
    PImage blobImage = getBlobImage(cropL, cropT, cropR - cropL, cropB - cropT);

    if(displayImages == true) {
      //image(context.rgbImage(), 0, 0);
      image(blobImage, 0, 0);
      
      noFill();
      stroke(0,255,0);
      
      // Rectangle
      line(cropL, cropT, cropL, cropB); // Left Crop 
      line(cropR, cropT, cropR, cropB); // Right Crop
      line(cropL, cropT, cropR, cropT); // Top Crop
      line(cropL, cropB, cropR, cropB); // Bottom Crop
      
      // Polygon
      beginShape();
        for(PVector v : poly) {
          vertex(v.x, v.y); 
        }
      endShape(CLOSE);
    }
    
    // Blob Detection
    bd.computeBlobs(blobImage.pixels); 
    drawBlobsAndEdges(true, false);
    
    // Assign Coordinates
    handX = blobX;
    handY = blobY;
    
    if(zone == true) {
    // Update XY Positions To Test If Over Circles 
    updateXY(handX, handY);
      if(displayImages == true) {
        noStroke();
        fill(0, 0, 255);
        ellipseMode(CENTER);
        ellipse(handX, handY, 20, 20);
      }
    }
    
    // Display Circles
    for(int i = 0; i < circle.length; i++) {
      circle[i].display(); 
    }
    
    // Check If Its Safe To Send A New Message
    if(checkTimer == true && msgReady == false) {
      if(oldBlobX == blobX && oldBlobY == blobY) {
        if(debugToConsole) {
          println("Cursor Is Stuck..."); 
        }
      }   
      else {
        resetGlobalTimer();
      }
    }
    
    
    if(frameCount % 6000 == 0) {
      if(zone == false) {
        println (hour()+":"+minute()+":"+second()+" Free Memory: "+Runtime.getRuntime().freeMemory()/1024+" K;");
        System.gc();
        println"Garbage collected");
        println (hour()+":"+minute()+":"+second()+" Free Memory: "+Runtime.getRuntime().freeMemory()/1024+" K;\n");
      }
      if(debugToConsole) {
        int fps = round(frameRate);
        println("Kinect Sketch Running At " + fps + " Frames Per Second"); 
      } 
    }
    
  
  }
}

// -------------------------------- //



