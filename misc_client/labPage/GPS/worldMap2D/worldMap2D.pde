
// IMPORTS

// DECLARATIONS
WorldMap wmap;
Point[] cities;

// VARIABLES
int width = 1000;
int height = width/2;

//--

void setup() {
  size(width, height);
  ellipseMode(CENTER);
  smooth();

  wmap = new WorldMap();
  cities = new Point[] {
    wmap.getPoint(52.31, 13.25) // Berlin
  };

}

//--

void draw() {
 wmap.drawBackground();

 fill(255, 150, 0);
 for (int i = 0; i < cities.length; i++) {
   ellipse(cities[i].x, cities[i].y, 14, 14);
  }

}

//--


