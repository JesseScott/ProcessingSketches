
// -------------------------------- //

void keyPressed() {
  if(runCalibration == true) {
    // Crop Calibration
    if(cropCalib == true) {
      // Select State/Line to Modify
      if(key == 'l') {
        calibState = 1;
      }
      if(key == 'r') {
        calibState = 2;
      }
      if(key == 't') {
        calibState = 3;
      }
      if(key == 'b') {
        calibState = 4;
      }
      // Save Positions
      if(key == 's') {
        try {
          if(debugToConsole) {
            println("Attempting To Save Crops To File...");
          }
          
          String l = str(cropL);
          String r = str(cropR);
          String t = str(cropT);
          String b = str(cropB);        
          
          BufferedWriter writer = new BufferedWriter(new FileWriter(dataPath("") + cropFile, false));
          writer.write(l);
          writer.newLine();
          writer.write(r);
          writer.newLine();
          writer.write(t);
          writer.newLine();
          writer.write(b);
          writer.newLine();
          writer.flush();
          writer.close();
          if(debugToConsole) {
            println("Saved Crops To File Successfully...");
          }
          cropCalib = false;
          if(debugToConsole) {
            println("Switching To Circle Calibration");
          }
          circleCalib = true;
          
        } 
        catch (IOException e) {
          if(debugToConsole) {
            println("Couldnt Save Crops To File... ??");
          }
          e.printStackTrace();
        }
      }
      // Modify Line By State
      if(key == CODED) {
        // Left Crop Area
        if(calibState == 1) { 
          if(keyCode == LEFT) {
            cropL--; 
          }
          else if(keyCode == RIGHT) {
            cropL++; 
          }
        } 
        // Right Crop Area
        if(calibState == 2) { 
          if(keyCode == LEFT) {
            cropR--; 
          }
          else if(keyCode == RIGHT) {
            cropR++; 
          }
        }
        // Top Crop Area
        if(calibState == 3) { 
          if(keyCode == UP) {
            cropT--; 
          }
          else if(keyCode == DOWN) {
            cropT++; 
          }
        }
        // Bottom Crop Area
        if(calibState == 4) { 
          if(keyCode == UP) {
            cropB--; 
          }
          else if(keyCode == DOWN) {
            cropB++; 
          }
        }
      }
    // Circle Calibration
    }
    if(circleCalib == true) {
     
      
    }
  }
}

// -------------------------------- //

void mousePressed() {
  if(runCalibration == true) {
    if(circleCalib == true) {
      if(circleCount < numButtons) {
        if(debugToConsole) {
          println("Creating Button Number " + circleCount);
        }
        circle[circleCount] = new CircleButton(mouseX, mouseY, sizeButton, buttonColor, highlight, newTimer); 
        circX[circleCount] = mouseX;
        circY[circleCount] = mouseY;
        
        if(debugToConsole) {
          println("circX " + circleCount + " X is " + circX[circleCount]);
          println("circY " + circleCount + " Y is " + circY[circleCount]);
        }
        
        circleCount++;
      }
      else if(circleCount == numButtons) {
        try {
          if(debugToConsole) {
            println("Attempting To Save Circles To File...");
          }
          
          BufferedWriter writer = new BufferedWriter(new FileWriter(dataPath("") + circFile, false));
          for(int i = 0; i < circX.length; i++) {
            String x = str(circX[i]);
            String y = str(circY[i]);
            writer.write(x);
            writer.newLine();
            writer.write(y);
            writer.newLine();            
          }
          writer.flush();
          writer.close();
          if(debugToConsole) {
            println("Saved Circles To File Successfully...");
            println();
          }
          circleCalib = false; 
          runCalibration = false;
          if(debugToConsole) {
            println("Switching To Kinect Mode...");
            println();
          }
        } 
        catch (IOException e) {
          if(debugToConsole) {
            println("Couldnt Save Circles To File... ??");
          }
          e.printStackTrace();
        }
      }
    } 
  }
}

