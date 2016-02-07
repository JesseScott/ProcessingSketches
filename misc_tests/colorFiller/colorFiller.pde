
color red = color(255, 0, 0, 10);
color green = color(0, 255, 0, 10);
color blue = color(0, 0, 255, 10);

int counter = 1;

void setup() {
  size(240, 420);
  background(255);
  smooth();
}

void draw() {
  noStroke();
    
  if(counter == 1) {
    fill(red);
  }  
  else if(counter == 2) {
    fill(green); 
  }
  else if(counter == 3) {
    fill(blue); 
  }
    
  if (mousePressed == true) {
    ellipse(mouseX, mouseY, 50, 50);
  }
  
 }

void mouseReleased() {
 counter++;
 if(counter == 4) {
   counter = 1; 
 }
 println(counter);
} 

