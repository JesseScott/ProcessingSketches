
float PMX, PMY, newX, newY;
 
//-----------------------------------------------------------------------------------------

void setup() {
  size(screenWidth, screenHeight);
  background(0);
  smooth();
  stroke(255);
  strokeWeight(5);
}

//-----------------------------------------------------------------------------------------

void draw() {

}
 
//-----------------------------------------------------------------------------------------
 
void mouseReleased() {
 println("RELEASED");
 
} 

void mousePressed() {
  println("PRESSED");
  PMX = mouseX;
  PMY = mouseY;
}

void mouseDragged() {
 println("DRAGGED");
 PMX = mouseX;
 PMY = mouseY;
 newX = lerp(pmouseX,mouseX, 0.1);
 newY = lerp(pmouseY,mouseY, 0.1);
 line(newX, newY, mouseX, mouseY);
 
}

//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent me) {


  return super.surfaceTouchEvent(me);
}

//-----------------------------------------------------------------------------------------

void keyPressed() {
    // Clear Screen if the MENU key is pressed
    background(0);
}


