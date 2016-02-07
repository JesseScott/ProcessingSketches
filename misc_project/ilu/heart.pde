



// -----------------------------
// HEARTS
// -----------------------------

class Heart {

  float xpos;
  float ypos;
  float speed;
  PImage img;

  Heart(float _xpos, float _ypos, float _speed) {
     xpos = _xpos;
     ypos = _ypos;
     speed = _speed;
     img = heart;
  }

  void update() {
    if(ypos > height) {
      ypos = random(-200, -100);
      speed = random(4); 
    }
    
    ypos += speed;
  }
  
  void display() {
    image(img, xpos, ypos, heart.width/2, heart.height/2);
  }
  
}


