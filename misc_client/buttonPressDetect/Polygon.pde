
// POLYGON DETECTION
// -------------------------------- //
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
        inPoly = true;
      }
    }
    else {
      inPoly = false; 
    }
    j = i;
  }
  return oddNodes;
}
