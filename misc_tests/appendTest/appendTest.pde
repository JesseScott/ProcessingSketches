PVector[] theLine; //PVector array
PVector current;


void setup(){
size(200,200);
  theLine = new PVector[5]; //five blank spots to start
  current = new PVector();
}


void draw(){


}

void mouseReleased() {
  current = new PVector(mouseX,   mouseY); 
  append(theLine, current);
  println(current);
}
