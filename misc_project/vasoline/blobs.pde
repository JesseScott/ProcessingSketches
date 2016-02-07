// ==================================================
// drawBlobsAndEdges()
// ==================================================

int bw = 640;
int bh = 480;
  
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
    b = theBlobDetection.getBlob(n);
     if (b != null) {
      // Edges
        if (drawEdges) {
          //canvas.beginDraw();
            canvas.strokeWeight(strokeSize);
  	    canvas.stroke(strokeColor);
  	    for (int m = 0; m < b.getEdgeNb(); m++) {  
              eA = b.getEdgeVertexA(m);
  	      eB = b.getEdgeVertexB(m);
  	      if (eA !=null && eB !=null)
  		canvas.line(eA.x*bw, eA.y*bh, eB.x*bw, eB.y*bh);
  	     }
          //canvas.endDraw();
        }

	// Blobs
	if (drawBlobs) {
          canvas.beginDraw();
            canvas.strokeWeight(blobSize);
	    canvas.stroke(blobColor);
	    canvas.rect(b.xMin*width,b.yMin*height,b.w*width,b.h*height);
          canvas.endDraw();
        }

      }
   }
 }
 
 
 //-----------------------------------------------------------------------------------------
