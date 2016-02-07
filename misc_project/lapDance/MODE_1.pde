
//-----------------------------------------------------------------

PShape ball;
int xspeed = 2;  
int yspeed = 2;  
int xdirection = 1;  
int prevY, currY;

float mapX, mapY;
float vx = width/2;
float vy;
float ax = width/2;
float ay;
float x = width/2;
float y = 0;
float ballSize;
float friction = -0.9;
float gravity = 0.05;
float spring = 0.05;

//-------------

void Mode_1() {
  // BOUNCING BALL
  pushStyle();    
  pushMatrix();
  
  // Screen
  ellipseMode(CENTER);
  smooth();
  
  // Bounce
  prevY = currY;
  currY = SMSVals[2] / 5;
  gravity = 0.05;
  
  if(prevY < currY + 1) {
    gravity = 1; 
    gravity++;
  }
  else if(prevY > currY && y + ballSize/2 >= height ) {
    y -= 5;
  }
  
  // Calculate
  mapX = round(map(SMSVals[0] /10, -25, 25, -24, 24));
  
  vx -= ax;
  vy -= ay;
  vy += gravity;
  x += vx;
  y += vy;
  x += xspeed * xdirection;
  x += mapX;
  
  // Borders
  if (x + ballSize/2 +32 >= width) {
    x = width - ballSize/2 -32;
    xdirection *= -1;
    vx *= friction; 
  }
  else if (x - ballSize/2 -32 <= 0) {
    x = ballSize/2 + 32;
    xdirection = 1;
    vx *= friction;
  }
  if (y + ballSize/2 >= height) {
    y = height - ballSize/2 - 4;
    vy *= friction; 
  } 
  else if (y - ballSize/2 <= 0) {
    y = ballSize/2;
    vy *= friction;
  }

  // Draw
  stroke(255, 55, 5, 205);
  //noStroke();
  noFill();
  fill(255, 55, 5, 205);
  ambientLight(101, 101, 101);
  directionalLight(51, 102, 126, -1, 0, 0);
  
  // Shape
  translate(x, y -8);
  rotateX(SMSVals[0] / 6);
  rotateY(SMSVals[1] / 8);
  sphere(ballSize/2);

  
  
  popMatrix();
  popStyle();
}

//-----------------------------------------------------------------

