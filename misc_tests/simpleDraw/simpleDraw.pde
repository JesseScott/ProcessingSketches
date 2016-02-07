

void setup() {
  size(400,400);
  background(255);
  
}


void draw() {
  stroke(0);

  
}

void mouseDragged() {
  line(mouseX, mouseY, pmouseX, pmouseY);
}

void keyPressed() {
 save("output.jpg"); 
}
