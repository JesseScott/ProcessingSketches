int w = 200; // canvas size
int n = 25;  // number of grid cells
int d = w/n; // diameter of a grid cell
boolean[][] memory = new boolean[n][n]; // core memory ;-)

void setup() {
  size(w, w);
  noSmooth();
}

void draw() {
 
  // draw the raster
  background(255);
  scale(d);
  strokeWeight(1.0/d);
  for (int x=0; x<n; x++) {
    for (int y=0; y<n; y++) {
      int r = memory[x][y] ? 1 : 0;
      line(x, y+r, x+1, y+1-r);
    }
  }
 
  // rescale and constrain mouse coordinates
  int mX = constrain(mouseX/d, 0, n-1);
  int pmX = constrain(pmouseX/d, 0, n-1);
  int mY = constrain(mouseY/d, 0, n-1);
  int pmY = constrain(pmouseY/d, 0, n-1);
 
  // flip line when the mouse moves to a new square
  if(mX != pmX || mY != pmY) {
    memory[mX][mY] = !memory[mX][mY];
  }
 
}
