
// BLOB DETECTION
// -------------------------------- //

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {	
  Blob b;
  EdgeVertex eA,eB;
  for (int n = 0 ; n < bd.getBlobNb() ; n++) {
    if(debugToConsole) {
      //println("There Are " + bd.getBlobNb() + " Blobs Detected...");
    }
    b = bd.getBlob(n);
      if (b!= null) {
        // Edges
        if (drawEdges) {
          noFill();
          strokeWeight(2);
          stroke(0, 255, 255);
          beginShape();
            for (int m = 0; m < b.getEdgeNb(); m++) {
              eA = b.getEdgeVertexA(m);
              eB = b.getEdgeVertexB(m);
                if (eA != null && eB != null) {
                  vertex(eA.x * width, eA.y * height);
                }
            }
          endShape(CLOSE);    
        }          
        // Blobs
        if (drawBlobs) {
          strokeWeight(1);
          noFill();
          stroke(255,0,0);
          rectMode(CORNER);
          // If Blobs Are Within Crop Area
          if(b.xMin * width > cropL && b.xMin * width < cropR && b.yMin * height > cropT && b.yMin * height < cropB) {
            // If The Blob Is Over A Certain Size
            if(b.w > blobMin && b.w < blobMax) {
              if(debugToConsole) {
                //println("Valid Blobs Are Numbers " + n);
              }
              zone = true;
              if(displayImages == true) {
                rect(b.xMin*width,b.yMin*height,b.w*width,b.h*height);
              }
              int s = 0;
              if(b.w > s) {
                s = n;
                if(debugToConsole) {
                  //println("Largest Blob Is " + n);
                }
              }
              // Set XY to largest blob XY
              blobX = (bd.getBlob(s).xMin * width)  + ((bd.getBlob(s).w * width)/2) ;
              blobY = (bd.getBlob(s).yMin * height) + ((bd.getBlob(s).h * height)/2);
            }
          }
          else {
            zone = false;
          }      
        }
      }
  }
  if(bd.getBlobNb() == 0){
    // If Theres No Blobs, Reset The Timer and Blob Position (in case the 'mouse' gets stuck on a trigger)
    for(int i = 0; i < circle.length; i++) {
      circle[i].resetTimer = millis();
    }   
    blobX = blobY = 0.0;
    zone = false;
  } 
} 

// -------------------------------- //

