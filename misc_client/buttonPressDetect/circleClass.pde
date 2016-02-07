
// BUTTON CLASS
// -------------------------------- //

class Button {
  // Contsructor
  int x, y;
  int size;
  color baseColor, highlightColor;
  color currentColor;
  boolean over = false;
  boolean pressed = false;
  int resetTimer;
  
  // Update
  void update() {
    if( over() ) {
      currentColor = highlightColor;
    } 
    else {
      currentColor = baseColor; 
    }
  }
  // Pressed
  boolean pressed() {
    if(over) {
      return true; 
    }
    else {
      return false;
    }
  }
  // Over
  boolean over() {
    return true; 
  }
  // Over Circle
  boolean overCircle(int x, int y, int diameter) {
    float disX = x - handX;
    float disY = y - handY;
    if( sqrt(sq(disX) + sq(disY)) < diameter/2 && zone == true) {
      return true;  
    }
    else {
      return false; 
    }
  }
}

// CIRCLE CLASS
// -------------------------------- //

class CircleButton extends Button { 
  
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight, int _newTimer)  {
    x = ix;
    y = iy;
    size = isize;
    baseColor = icolor;
    highlightColor = ihighlight;
    currentColor = baseColor;
    resetTimer = _newTimer;
  }
  
  // Over
  boolean over() {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }
  // Trigger
  void trigger(int i) {
    sendIndex(i);  
  }
  // Display
  void display() {
    noStroke();
    fill(currentColor);
    ellipseMode(CENTER);
    ellipse(x, y, size, size);
  }
}

// -------------------------------- //



