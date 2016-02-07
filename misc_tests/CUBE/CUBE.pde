void setup() {
  size(1024, 768, P3D);
  background(255);
  stroke(0);
  
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(180);
  beginShape(QUADS);
    noFill();

/*
  // FRONT
  vertex(-1,  1,  1);
  vertex( 1,  1,  1);
  vertex( 1, -1,  1);
  vertex(-1, -1,  1);
*/

/* 
  // RIGHT
  vertex( 1,  1,  1);
  vertex( 1,  1, -1);
  vertex( 1, -1, -1);
  vertex( 1, -1,  1);
*/

  // BACK
  vertex( 1,  1, -1);
  vertex(-1,  1, -1);
  vertex(-1, -1, -1);
  vertex( 1, -1, -1);

/* 
  // LEFT
  vertex(-1,  1, -1);
  vertex(-1,  1,  1);
  vertex(-1, -1,  1);
  vertex(-1, -1, -1);
*/

  // BOTTOM
  vertex(-1,  1, -1);
  vertex( 1,  1, -1);
  vertex( 1,  1,  1);
  vertex(-1,  1,  1);

/*
  // TOP
  vertex(-1, -1, -1);
  vertex( 1, -1, -1);
  vertex( 1, -1,  1);
  vertex(-1, -1,  1);
*/

  endShape();
  popMatrix();
}
