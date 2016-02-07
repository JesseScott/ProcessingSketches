


import processing.net.*;

Server s;
Client c;
String input;
String message = "";
int opacity = 255;

void setup() {
  size(400, 200);
  background(0);
  s = new Server(this, 8080); // Start a simple server on a port
}

void draw() {
  background(0);
  // Receive data from client
  c = s.available();
  if (c != null) {
    input = c.readString();
    if(input != null) {
      println();
      println("Server Received New Data");
      println(input + "received at " + millis());
      println();
      message = input;
      opacity = 255;
    }
  }
  else {
    //message = ""; 
  }
  fill(opacity);
  opacity--;
  textSize(64);
  textAlign(CENTER);
  text(message, width/2, height/2);
}
