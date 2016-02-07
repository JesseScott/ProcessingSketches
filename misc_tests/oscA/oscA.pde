import oscP5.*;
import netP5.*;

OscP5 oscP5;

float x, y;

void setup() {
 
  
  oscP5 = new OscP5(this, "192.168.1.6", 11000);
}

void draw() {

}



public void oscEvent(OscMessage msg) {
  println(msg);
  if(msg.checkAddrPattern("/blitz") && msg.checkTypetag("ff")) {
    x = msg.get(0).floatValue();  
    y = msg.get(1).floatValue(); 
    println(x + " " + y );
  }
} 



