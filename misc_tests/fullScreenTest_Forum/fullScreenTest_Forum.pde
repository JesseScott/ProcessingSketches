public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(displayWidth, displayHeight);
  background(255, 0, 0);
  frame.setLocation(0, 0); //This does not work
}

void draw() {
  println(millis());
}
