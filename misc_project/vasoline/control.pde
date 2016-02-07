
 //-----------------------------------------------------------------------------------------
 // CP5 
  
 // STROKE COLOR + SIZE
 
 void STROKE_SZ(int StrokeSize) {
    strokeSize = (StrokeSize);
  }
  
 void STROKE_R(int StrokeR) {
    strokeR = (StrokeR);
  }

 void STROKE_G(int StrokeG) {
    strokeG = (StrokeG);
  }
  
 void STROKE_B(int StrokeB) {
    strokeB = (StrokeB);
  } 
  
 void STROKE_A(int StrokeA) {
    strokeA = (StrokeA);
  } 
  
 void RAN_STROKE(boolean theFlag) {
  if(theFlag == true) {
    strokeR = int(random(255));
    strokeG = int(random(255));
    strokeB = int(random(255));
  }
 }
  
 // BLOB COLOR + SIZE
 
 void BLOB_SZ(int BlobSize) {
    blobSize = (BlobSize);
  }
  
 void BLOB_R(int BlobR) {
    blobR = (BlobR);
  }

 void BLOB_G(int BlobG) {
    blobG = (BlobG);
  }
  
 void BLOB_B(int BlobB) {
    blobB = (BlobB);
  } 
  
 void BLOB_A(int BlobA) {
    blobA = (BlobA);
  } 
  
 void RAN_BLOB(boolean theFlag) {
  if(theFlag == true) {
    blobR = int(random(255));
    blobG = int(random(255));
    blobB = int(random(255));
  }
 }
 
 // BLUR AMOUNT
 
 void BLUR_AMT(int BlurAmt) {
   blurAmt = (BlurAmt);
 }

 // CLEAR
 void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    background(0);  
    tracker.erase();
  }
 }  
 
 // DRAW
 
 void BLOB(boolean theFlag) {
    if(theFlag == true) {
      drawBlob = true;
    } else if (theFlag == false) {
      drawBlob = false;
    }
  }
  
 void IMG(boolean theFlag) {
    if(theFlag == true) {
      drawImg = true;
    } else if (theFlag == false) {
      drawImg = false;
    }
  }
 
 void BLURR(boolean theFlag) {
    if(theFlag == true) {
      drawBlur = true;
    } else if (theFlag == false) {
      drawBlur = false;
    }
  }
  
 void BG(boolean theFlag) {
    if(theFlag == true) {
      bg = true;
    } else if (theFlag == false) {
      bg = false;
    }
  }
  
 void PTS(boolean theFlag) {
    if(theFlag == true) {
      pts = true;
    } else if (theFlag == false) {
      pts = false;
    }
  }
  
// THRESHOLDS

 void BTHRESH(int BThresh) {
    bThresh = (BThresh);
    theBlobDetection.setThreshold(bThresh);
  }
  
 void KTHRESH(int Threshold) {
    kThresh = (Threshold);
    tracker.setThreshold(kThresh);
  }
  
 //-----------------------------------------------------------------------------------------
// N-S
// 935 is HALFWAY
// 1015 is at PILLAR
// DIAG + UP 2
// 1010 is just past BEAMER
// 

void keyPressed() {
  //int t = tracker.getThreshold();
  kThresh = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      kThresh+=5;
      tracker.setThreshold(kThresh);
    } 
    else if (keyCode == DOWN) {
      kThresh-=5;
      tracker.setThreshold(kThresh);
    }
    else if (keyCode == LEFT) {
      bThresh -= 0.05;
    }
    else if (keyCode == RIGHT) {
      bThresh += 0.05;
    }
  }
}



