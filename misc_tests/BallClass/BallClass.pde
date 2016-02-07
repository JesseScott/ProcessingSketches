
Ball ball;

void setup() {
  size(640, 480);
  smooth();
  
  ball = new Ball(width/2, height/2, 60);
}

void draw() {
  background(0, 255, 0);
  ball.move();
  ball.boundsDetect();
  ball.draw();
  
  println("The X Position is " + getX() + " and the Y Position is " + getY());
}

class Ball {
    
  float x, y;
  float xSpeed = 2.8;
  float ySpeed = 2.2;
  int bSize, bRadius;
  int xDirection = 1;
  int yDirection = 1;
  
  Ball(int _x, int _y, int _size) {
    x = _x;
    y = _y;
    bSize = _size;
    bRadius = bSize/2;
  } 
  
  void move() {
    x = x + (xSpeed * xDirection);
    y = x + (ySpeed * yDirection);
  }
  
  void draw() {
    fill(255, 0, 0);
    stroke(255);
    ellipse(x, y, bSize, bSize); 
    println("here");
  }
  
  void boundsDetect() {
    if (x > width - bRadius || x < bRadius) {
      xDirection *= -1;
    }
    if (y > height - bRadius || y < bRadius) {
      yDirection *= -1;
    }
      
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
}
