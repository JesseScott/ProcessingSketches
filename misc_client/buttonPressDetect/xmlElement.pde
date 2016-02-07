
// LOAD + PARSE XML
// -------------------------------- //

void loadXML() {
  xml = new XMLElement(this, "settings.xml");
  int numTags = xml.getChildCount();

  for(int i = 0; i < numTags; i++) {
    XMLElement kid = xml.getChild(i);
    int id = kid.getInt("id");
    if(id == 0) {
      numButtons = int( kid.getContent() ); 
    }
    else if(id == 1) {
      sizeButton = int( kid.getContent() );
    }
    else if(id == 2) {
      trigTime = int( kid.getContent() );
    }
    else if(id == 3) {
      ipAddress = kid.getContent();
    }
    else if(id == 4) {
      port = int( kid.getContent() );
    }
    else if(id == 5) {
       delayTime = int( kid.getContent() );
    }
    else if(id == 6) {
       tableHeight = int( kid.getContent() );
    }
    else if(id == 7) {
       zOffset = int( kid.getContent() );
    }
    else if(id == 8) {
       calibrate = kid.getContent();
    }   
    else if(id == 9) {
       display = kid.getContent();
    } 
    else if(id == 10) {
       debug = kid.getContent();
    } 
    else if(id == 11) {
       blobMin = float( kid.getContent() );
    } 
    else if(id == 12) {
       blobMax = float( kid.getContent() );
    }     
    else if(id == 13) {
       blobThresh = float( kid.getContent() );
    }   
  }
  
  // State
  if(calibrate.equals(truthTest) == true) {
    runCalibration = true;
    cropCalib = true;
  }  

  // Display
  if(display.equals(truthTest) == true) {
    displayImages = true; 
  } 

  // Debug
  if(debug.equals(truthTest) == true) {
    debugToConsole = true; 
  }
  else {
    println("DEBUGGING IS TURNED OFF.... DONT BE ALARMED IF YOU DONT SEE ANYTHING...."); 
  }
  
  if(debugToConsole) {
    println();
    println("Number of Buttons Will Be " + numButtons);
    println("Size of Buttons Will Be " + sizeButton);
    println("Trigger Time Will Be " + trigTime);
    println("IP Address Will Be " + ipAddress);
    println("Network Port Will Be " + port);
    println("Delay Time Will Be " + delayTime);
    println("Table Height Will Be " + tableHeight);
    println("Calibration ???  " + runCalibration);
    println("Display ???  " + displayImages);
    println("Blob Min Will Be " + blobMin);
    println("Blob Max Will Be " + blobMin);
    println("Blob Threshold Will Be " + blobThresh);
    println();
  }
  
}
