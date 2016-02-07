

// TIMERS
// -------------------------------- //

void resetGlobalTimer() {
  if( millis() - globalTimer > delayTime ) {
    if(debugToConsole) {
      println("Resetting Global Timer & Message Offset...");
    }
    // Tell The UpdateXYFunction That Its Safe To Send A New Message
    msgReady = true;
    checkTimer = false;
    // Reset The Timer
    globalTimer = millis();
  }
}

// -------------------------------- //
