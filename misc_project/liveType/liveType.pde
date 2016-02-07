
String liveType = "";
PFont typeStyle;

float x;
float y;

void setup() {
  size(1280, 960, JAVA2D);
  smooth();
  background(0);
  fill(255); 
  
  typeStyle = createFont("SansSerif-96.vlw", 192, true);
  textFont(typeStyle);
  textSize(192);
  textAlign(CENTER);
  
  x = width/2;
  y = height/2;
  
}

void draw() {
  background(0);

  if(frameCount % 10 == 0) {
    //x = x-1;
    x = x-(liveType.length());
  }

  text(liveType, x, y); 
  
}

void keyPressed() {
  if(key != CODED) {

    if(key == BACKSPACE) { 
      if (liveType.length() > 0) {
        println("Before " + liveType);
        liveType = liveType.substring(0, liveType.length()-1);
        println("After " + liveType);
      } 
    }
    else if(key == ENTER) {
      liveType = "";
      x = width/2;
    } 
    else {
      liveType += key; 
      //x = x-(liveType.length()*3); 
    }
  }
}
