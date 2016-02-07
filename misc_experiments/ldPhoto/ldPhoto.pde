

void setup() {
  size(screenWidth, screenHeight);
    background(0);
    noFill();
    translate(width/4, height/4);
    for(int i = 0; i < 512; i+=2) {
      //strokeWeight(i/32);
      int br = 32;
      int bg = 64;
      int bb = 128;
        stroke(255, 205 -i);
        ellipse(width/4, height/4, i - br, 800 - (i - br));
        stroke(205, 155 -i);
        ellipse(width/4, height/4, i + bg, 600 - (i + bg));
        stroke(155, 105 -i);
        ellipse(width/4, height/4, i - bb, 700 - (i - bb));
        stroke(255, i);
        ellipse(width/4, height/4, i*2, i*2);
    } 
  
  
}
