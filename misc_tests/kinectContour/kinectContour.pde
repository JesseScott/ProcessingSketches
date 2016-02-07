import processing.opengl.*;
import blobDetection.*;
import king.kinect.*;

float levels = 15;                    // number of contours
float factor = 1;                     // scale factor
float elevation = 55;                 // total height of the 3d model

float colorStart =  0;                // Starting degree of color range in HSB Mode (0-360)
float colorRange =  100;              // color range / can also be negative

float tolerance = 500;
float targetDepth = 0;

// Array of BlobDetection Instances
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];

PImage img;
PGraphics pg;
PImage depth;

void setup() {
  size(640,480, P3D);
 
  NativeKinect.init();
  NativeKinect.start();
  
  colorMode(HSB,360,100,100);
  
  depth = createImage(640,480,RGB);	
  pg = createGraphics(160, 120, P3D);
}

static final int gray(color value) { 
  return max((value >> 16) & 0xff, (value >> 8 ) & 0xff, value & 0xff);  
} 

 void draw() {
   background(0);
   println(frameRate);

  depth.pixels = NativeKinect.getDepthMap();
  depth.updatePixels();
  
  pg.beginDraw();
  fastblur(depth,8);
  pg.image(depth,0,0,160,120);
  pg.endDraw();
 
  //Computing Blobs with different thresholds 
  for (int i=0 ; i<levels ; i++) {
    theBlobDetection[i] = new BlobDetection(pg.width, pg.height);
    theBlobDetection[i].setThreshold(i/levels);
    theBlobDetection[i].computeBlobs(pg.pixels);
  }

  //Levels
  for (int i=0 ; i<levels ; i++) {
    translate(0,0,elevation/levels);	
    drawContours(i);
  }

}


void drawContours(int i) {
  Blob b;
  EdgeVertex eA,eB;

  for (int n=0 ; n<theBlobDetection[i].getBlobNb() ; n++) {
    b=theBlobDetection[i].getBlob(n);
    if (b!=null) {
      stroke((i/levels*colorRange)+colorStart,100,100);      // coloring the contours
      for (int m=0;m<b.getEdgeNb();m++) {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);
        if (eA !=null && eB !=null)
          line(eA.x*depth.width*factor, eA.y*depth.height*factor, eB.x*depth.width*factor, eB.y*depth.height*factor);
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      tolerance++;
    } else if (keyCode == DOWN && tolerance > 0) {
      tolerance--;
    } 
    println("tolerance: " + tolerance);
  } 
}



//FAST BLUR
void fastblur(PImage img,int radius){

  if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
     dv[i]=(i/div); 
  }
  
  yw=yi=0;
 
  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
   }
    for (x=0;x<w;x++){
    
      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
       } 
       p1=pix[yw+vmin[x]];
       p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }
  
  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      } 
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}


