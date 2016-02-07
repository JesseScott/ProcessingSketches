
// UPDATE XY
// -------------------------------- //

void updateXY(float x, float y) {
  for(int i = 0; i < circle.length; i++) {
    // Update All The Circles
    circle[i].update(); 
    // If XY Is Over 
    if(circle[i].over == true) {
      // If We've Waited Long Enough After The Last Message
      if(msgReady == true) { 
        // If The Current Time Minus The Last Triggered Time Is Greater Than The Trigger Delay 
        if(millis() - circle[i].resetTimer > trigTime) {              
          if(debugToConsole) {
            println("Triggering from UpdateXY");
          }
          // Set Current XY Locations, So We Can Test IF Cursor Is Stuck
          oldBlobX = x;
          oldBlobY = y;
          // Call The Trigger Method And Pass It The Circle Index That We Are Over
          circle[i].trigger(i);
          // Reset The Local Timer To The Current Time
          circle[i].resetTimer = millis();
          // Allow Us To Check If The Message Delay Has Expired
          checkTimer = true;
        }
      }
    }
    else {
      circle[i].resetTimer = millis();
    } 
  }
}

// -------------------------------- //


