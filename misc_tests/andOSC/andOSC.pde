 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;


void setup() {
  size(480, 800);

  frameRate(25);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("192.168.1.134",12000);

}

void draw() {
  background(100);  
}

void mousePressed() {
  oscP5.send("/test",new Object[] {new Float(mouseX), new Float(mouseY)}, myRemoteLocation);
  text("FOO", 240, 400);
}

