void setup() {
  size(screenWidth, screenHeight);
  frame.setLocation(0, 0); //This doesn't work
}

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void draw() {
  if(frameCount == 1) frame.setLocation(0, 0); //This does
 
  println(millis());
}
