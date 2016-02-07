// Android Example for Weave Magazine 02.11
//
// androidCameraSlitScan.pde
// Shows the basic use of the Camera
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
//
// With Code from Erik Pavey http://akeric.com
// Set Sketch Permissions : CAMERA
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

// Imports
import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.hardware.Camera.PreviewCallback;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.Surface;

// Declarations
CameraSurfaceView gCamSurfView;
PImage gBuffer;


Tuple[] captureColors;
Tuple[] drawColors;
int[] bright;
int increment = 5;
boolean cheatScreen;

void setup() {
  size(screenWidth, screenHeight, A2D);
  orientation(LANDSCAPE);
  background(0);
  
  int count = (640 * 480) / (increment * increment);
  bright = new int[count];
  captureColors = new Tuple[count];
  drawColors = new Tuple[count];
  for (int i = 0; i < count; i++) {
    captureColors[i] = new Tuple();
    drawColors[i] = new Tuple(0.5, 0.5, 0.5);
  }
  
}

void draw() {
  println(frameRate);
  background(0);
    noStroke();
    int index = 0;
    for (int j = 0; j < gBuffer.height; j += increment) {
      for (int i = 0; i < gBuffer.width; i += increment) {
        int pixelColor = gBuffer.pixels[j*gBuffer.width + i];
        int r = (pixelColor >> 16) & 0xff;
        int g = (pixelColor >> 8) & 0xff;
        int b = pixelColor & 0xff;
        bright[index] = r*r + g*g + b*b;
        captureColors[index].set(r, g, b);
        index++;
      }
    }
    sort(index, bright, captureColors);
    beginShape(QUAD_STRIP);
    for (int i = 0; i < index; i++) {
      drawColors[i].target(captureColors[i], 0.1);
      drawColors[i].phil();
      float x = map(i, 0, index, 0, width);
      //line(x, 0, x, height);
      vertex(x, 0);
      vertex(x, height);
    }
    endShape();

  println(frameRate);
}

//-----------------------------------------------------------------------------------------

void onResume() {
  super.onResume();
  // Create our 'CameraSurfaceView' objects, that works the magic:
  gCamSurfView = new CameraSurfaceView(this.getApplicationContext());
}

//-----------------------------------------------------------------------------------------





