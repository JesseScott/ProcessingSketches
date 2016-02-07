
//------------//

class WhiteStone {
  int xpos;
  int ypos;
  
  WhiteStone(int _xpos, int _ypos) {
    xpos = _xpos;
    ypos = _ypos;
  }
  
  void display() {
    strokeWeight(1);
    smooth();
    fill(255);
    ellipse(xpos, ypos, 40, 40);
  }
  
  void remove() {
    
    
  }
  
} //


//------------//


class BlackStone {
  int xpos;
  int ypos;
  
  BlackStone(int _xpos, int _ypos) {
    xpos = _xpos;
    ypos = _ypos;
  }
  
  void display() {
    strokeWeight(1);
    smooth();
    fill(0);
    ellipse(xpos, ypos, 40, 40);
    
  }
  
  void remove() {
    
    
  }
  
} //


//------------//
