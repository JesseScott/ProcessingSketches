
class Symbol {
  // Constructor
  float wide;
  float high;
  float xpos;
  float ypos;
  float zpos;
  float grav;
  float rotx;
  float roty;
  float rotz;
  PImage img;
  boolean filterImg;
  int erodeLevel;
  float trans;
  
  Symbol(float _xpos, float _ypos, float _zpos, float _gravity, float _rotx, float _roty, float _rotz) {
    xpos = _xpos;
    ypos = _ypos;
    zpos = _zpos;
    grav = _gravity;
    rotx = _rotx;
    roty = _roty;
    rotz = _rotz;
    
  }
  
  void init(PImage _img, boolean _filterImg, int _erodeLevel, float _trans) {
    wide = int(random(4,9)) * 24;
    img = _img;
    trans = _trans;
  }
  
  void update() {
    pushMatrix();
      translate(rotx, roty, rotz);
      ypos += grav;
        if(ypos >= 3*(height/4)) {
          filterImg = true;
        }
        if(ypos > height + wide) {
          ypos = -200; 
        }
    popMatrix();
  }
  
  
  void display() {
      if(filterImg == true) {
        erodeLevel++;
        //filter(ERODE, 2); 
      }
      tint(255, trans);
      image(img, xpos, ypos, wide, wide);
  }
  
  
  void remove() {
    
    
  }
  
}
