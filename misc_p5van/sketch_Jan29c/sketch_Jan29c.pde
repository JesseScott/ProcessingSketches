void draw() {
  frameRate(20);int x=frameCount%20*5;
  int c = int(random(2))*5;line(x+c, 95, x+5-c, 100);
  if (x==95) {
    PImage s = get();
    background(204);
    image(s, 0, -5);
  }
}
