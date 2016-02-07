void setup() {
  size(640,480);
}

void draw() {
  background(255);
  PVector[] verts=new PVector[4];
  // add corner points of quad
  verts[0]=new PVector(224,89);
  verts[1]=new PVector(385,89);
  verts[2]=new PVector(320,470);
  verts[3]=new PVector(260,470);
  // check if mouse pos is inside
  if(containsPoint(verts,mouseX,mouseY)) {
    fill(255,0,0);
  } else {
    noFill();
  }
  beginShape();
  for(PVector v : verts) {
    vertex(v.x,v.y);
  }
  endShape(CLOSE);
}

// taken from:
// http://hg.postspectacular.com/toxiclibs/src/tip/src.core/toxi/geom/Polygon2D.java
boolean containsPoint(PVector[] verts, float px, float py) {
  int num = verts.length;
  int i, j = num - 1;
  boolean oddNodes = false;
  for (i = 0; i < num; i++) {
    PVector vi = verts[i];
    PVector vj = verts[j];
    if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
      if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
        oddNodes = !oddNodes;
      }
    }
    j = i;
  }
  return oddNodes;
}

