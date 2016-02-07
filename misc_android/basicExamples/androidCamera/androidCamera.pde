// Android Example for Weave Magazine 02.11
//
// androidCamera.pde
// Shows the basic use of the Camera
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
//
// With Code from Eric Pavey http://www.akeric.com
//
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

//-----------------------------------------------------------------------------------------

void setup() {
  size(screenWidth, screenHeight, A2D); // 800 x 480 on Nexus One
  orientation(LANDSCAPE);
  background(0);
}

//-----------------------------------------------------------------------------------------

void draw() {
  println(frameRate);
  // Nothing to see here...
}

//-----------------------------------------------------------------------------------------

void onResume() {
  super.onResume();
  // Create our 'CameraSurfaceView' objects, that works the magic:
  gCamSurfView = new CameraSurfaceView(this.getApplicationContext());
}


