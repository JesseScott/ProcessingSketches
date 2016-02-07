

  //-----------------------------------------------------------------------------------------

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
	
  if (detect == true) {
  
    noFill();
    Blob b;
    EdgeVertex eA,eB;
         
      for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++) {
        if (blbs[n] == true){
	  b=theBlobDetection.getBlob(n);
          // println(n); // print the number of blobs
        
	  if (b!=null) {
	  
            // Edges
	    if (drawEdges) {
	      strokeWeight(lineThick);
	      stroke(0, 255, 0);
              beginShape();
	       for (int m=0; m<b.getEdgeNb(); m++) {
		 eA = b.getEdgeVertexA(m);
		 eB = b.getEdgeVertexB(m);
		   if (eA !=null && eB !=null) {
	            vertex(eA.x*cam.width/4, eA.y*cam.height/4);

                    if (export == true) {
                    output.println("G1" + " " + "X" + eA.x*cam.width + " " + "Y" + eA.y*cam.height); 
                    // maybe divide by 4 ??

                    String[] xy = new String[2];
                    String x = str(eA.x);
                    String y = str(eA.y);
                    String joinedXY = join(xy, " ");
                    saveStrings("strings.txt", xy);
                    
                    
                    }
		   }
               }
              endShape();    
              if (export == true) {
                //output.println("G1" + " " + "X" + eA.x + " " + "Y" + eA.y);
                output.flush();
                output.close();
                xport = " exporting";
              }
	    }          
          
         
  
          
	    // Blobs
	    if (drawBlobs) {
	      strokeWeight(1);
	      stroke(255,0,0);
	      rect(b.xMin*width,b.yMin*height,b.w*width,b.h*height);
	    }
	  }
            if (export == false) {
              fill(255,255,255);
              xport = " detecting";
              font = createFont("Verdana", 12);
              pushMatrix();
              scale(-1,1);
              translate(-50-320,-50-241);
              translate(-50-320,50+241);
              text(n, 50+b.xMin*cam.width, 50+b.yMin*cam.height);
              popMatrix();
              noFill();
            }
        }
      }
  }
  
} // end drawBlobs

  //-----------------------------------------------------------------------------------------
