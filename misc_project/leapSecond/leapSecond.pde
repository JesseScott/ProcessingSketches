int s;
int d = 1;
int f = 1;

void setup() {
 size(1024, 768, P2D); 
 background(0);
 smooth(); 
 s = millis();
}


void draw() {
  //background(0);

  if(d >= f) {
    float r = random(0.0, d);
    float g = random(0.0, d);
    float b = random(0.0, d);
    
    strokeWeight(d/((r+g+b)/3));
    
    if(d % 2 == 0) {
      noFill();
      stroke(r, g, b, d);
    }
    else if(d % 2 == 1) {
      noStroke();
      fill(r, g, b, d); 
    }
    
    if(d % 4 == 0) {
      line(d, d, r, r);
    }
    else if(d % 4 == 1) {
      ellipse(d, d, r, r); 
    }
    else if(d % 4 == 2) {
      rect(d, d, r, r);
    }
    else if(d % 4 == 3) {
      triangle(d, d, d, r, r, r);
    }
    

  }
  
  d = millis() - s;
  f = d;
  
  if(d >= 1000) {
    exit(); 
  }
}
