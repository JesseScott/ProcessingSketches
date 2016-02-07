
// KINECT
// -------------------------------- //

PImage getBlobImage(int sx, int sy, int w, int h) {
  PVector[] realWorldMap = context.depthMapRealWorld();
  PImage blobImage = createImage(context.depthWidth(), context.depthHeight(), RGB);
  int maxY = max(context.depthHeight()-sy, sy + h);
  int maxX = min(context.depthWidth()-sx, sx + w);

  for (int y = sy; y < maxY; y++) {
    for (int x = sx; x < maxX; x++) {
      int index = x + y * context.depthWidth();
      PVector realWorldPoint = realWorldMap[index];
      color blobColor = blobNo;
      if (realWorldPoint.z < tableHeight && realWorldPoint.z > tableHeight - zOffset) {
        
        // Projective
        PVector pos = new PVector(realWorldPoint.x, realWorldPoint.y);
        context.convertRealWorldToProjective(realWorldPoint, projection); 
        
        // Contains
        if(containsPoint(poly, projection.x, projection.y)) {
          //println("YESSSS"); 
          blobColor = blobYes;
        }
      }
      blobImage.pixels[index] = blobColor;
    }
  }
  return blobImage;
}


// -------------------------------- //
