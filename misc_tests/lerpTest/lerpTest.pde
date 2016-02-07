int x, y;
color prev, next, mix;

void setup() {
  
  size(255, 255); 
  
}

void draw() {
  
  background(0);
  
  float m = millis()  % 10;
  println(m);
  mix = lerpColor(prev, next, m);
    
  fill(prev);
  rect(0, 0, width, 85);

  fill(mix);
  rect(0, 85, width, 85);
  
  fill(next);
  rect(0, 170, width, 85);
  
}

void mousePressed() {
  
  prev = color(mouseX, 99, 99);
  next = color(mouseY, 99, 99);
  
}
