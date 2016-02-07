
class WorldMap {
  int x, y, w, h;
  PImage earth;

  WorldMap() {
   this(0, 0, width, height);
  }

  WorldMap(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    earth = loadImage("earth_4096.jpg");
  }

  void drawBackground() {
    image(earth, x, y, w, h);
  }

  Point getPoint(float phi, float lambda) {
    return new Point(x + ((180+lambda)/360)*w, y + h - ((90+phi)/180)*h);
  }

}
 
//--

class Point extends Point2D {
  Point(float x, float y) { super(x, y); }
}

class Point2D {
  float x, y;
  Point2D(float x, float y) {
    this.x = x; this.y = y;
  }
}
 
