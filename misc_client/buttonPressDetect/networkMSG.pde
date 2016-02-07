
// SEND NETWORK MESSAGES
// -------------------------------- //

void sendIndex(int index) {
  if(debugToConsole) {
    println("Triggered #" + index);
    println();
    println("Connecting to Server... ");
  }
  // Reopen connection to server...
  client = new Client(this, ipAddress, port);
  // Receive data from server
  if (client.available() > 0) {
    String input;
    input = client.readString();
    if(debugToConsole) {
      println("Server Says " + input);
    }
  }
  if(debugToConsole) {
    println("Client Sending Video Index...");
  }
  // Pad Message with '00'
  message = nf(index, 3);
  // Send Video Index
  if (client.active() == true) {
    client.write(message + "\n");
    client = null;
  }
  else {
    if(debugToConsole) {
      println("Client Not Connected To The Server...");
    }
  }
  // Turn Off MSG Flag
  msgReady = false;
  
}

// -------------------------------- //

