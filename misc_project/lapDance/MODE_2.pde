
//-----------------------------------------------------------------

float pos[] = new float[2]; 
float _pos[] = new float[2];
PGraphics vis;
float rotationY = 0;
boolean clockWise = false;

//-------------

void Mode_2() {
  // CARTESIAN GRID
  pushStyle();    
  pushMatrix();
 
  // Screen
  background(255);

  // World
  translate(width/2, height/2, 0);
  rotateY(rotationY);   
  
  // Floor
  pushMatrix();
  scale(240);
  beginShape(QUADS);
    noStroke();
    fill(200, 50);
    vertex( 1,  1, -1);
    vertex(-1,  1, -1);
    vertex(-1, -1, -1);
    vertex( 1, -1, -1);

    fill(150, 75);
    vertex(-1,  1, -1);
    vertex( 1,  1, -1);
    vertex( 1,  1,  1);
    vertex(-1,  1,  1);
  endShape();
  popMatrix();
  
  // Position
  translate(0 - (width/2), 0 - (height/2), 10);
  _pos[0] = pos[0]; 
  _pos[1] = pos[1]; 
  //_pos[2] = pos[2];    
  pos[0] = map(SMSVals[0], -250, 250, 0.0, 1.0) * width;
  pos[1] = map(SMSVals[1], -250, 250, 0.0, 1.0) * height;
  //pos[2] = SMSVals[2];

  // Draw
  float shade = rotationY * frameRate;
  vis.beginDraw();
    vis.strokeWeight(2);
    vis.stroke(shade + 50, shade ,shade, 100);
    vis.fill(255, shade ,shade, 100);
    //vis.point(pos[0], pos[1], pos[2]);
    vis.line(pos[0], pos[1], _pos[0], _pos[1]);
  vis.endDraw();    
  image(vis, 0, 0);    

  // Rotation
  if(clockWise == false) {
    rotationY -= 0.001;
    //pos[2] -= 1;
  }
  else if(clockWise == true) {
    rotationY += 0.001;
    //pos[2] += 1;
  }
  if(rotationY >= 0.5) {
    clockWise = false; 
  }
  else if(rotationY <= -0.5) {
    clockWise = true; 
  }

  popMatrix();
  popStyle();
}



//-----------------------------------------------------------------

