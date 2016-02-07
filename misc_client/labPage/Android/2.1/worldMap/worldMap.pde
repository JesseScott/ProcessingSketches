WorldMap wmap;
Point[] cities;

void setup() {
  size(1000, 600);
  ellipseMode(CENTER);
  smooth();

  wmap = new WorldMap();
  cities = new Point[] {
   wmap.getPoint( 48.45,     2.35),  // Paris
   wmap.getPoint( -34.60, - 58.38),  // Buenos Aires
   wmap.getPoint(  17.96,  102.62),   // Vientiane
   wmap.getPoint(  52.31,  13.25)   // Berlin
  };

}

void draw() {
 wmap.drawBackground();

 fill(255, 150, 0);
 for (int i = 0; i < cities.length; i++) {
   ellipse(cities[i].x, cities[i].y, 14, 14);
  }

}

class WorldMap {
  int x, y, w, h;
  PImage raster;

  WorldMap() {
   this(0, 0, width, height);
  }

 WorldMap(int x, int y, int w, int h) {
   if (h >= w/2) {
     this.w = w;
     this.h = w/2;
     this.x = x;
     this.y = (h - this.h)/2;
   } else {
     this.h = h;
     this.w = 2*h;
     this.x = (w - this.w)/2;
     this.y = y;
   }
   raster = loadImage("world_longlatwgs3.png");
}

 void drawBackground() {
   image(raster, x, y, w, h);
}

 Point getPoint(float phi, float lambda) {
   return new Point(
     x + ((180+lambda)/360)*w,
     y + h - ((90+phi)/180)*h
   );
}

}

class Point extends Point2D {
Point(float x, float y) { super(x, y); }
}

class Point2D {
float x, y;
Point2D(float x, float y) {
   this.x = x; this.y = y;
}
}
 
