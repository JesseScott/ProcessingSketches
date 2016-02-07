// Android Example for Weave Magazine 02.11
//
// androidTypography.pde
// Shows the basic use of the Accelerometer
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
//
// With Code from Eric Pavey - 2010-10-10 http://www.akeric.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

// Imports required for sensor usage:
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;

//-----------------------------------------------------------------------------------------

// Screen Data:
float sw, sh;
float ts = 75;
// Font Data:
String[] fontList;
PFont androidFont;
// Keyboard Input
String msg = "";

// Setup variables for the SensorManager, the SensorEventListeners,
// the Sensors, and the arrays to hold the resultant sensor values:
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;

//-----------------------------------------------------------------------------------------

void setup() {
 
 size(screenWidth, screenHeight, A2D); // A3D aliases text
 sw = screenWidth; // 480.0 on N1
 sh = screenHeight; // 800.0 on N1 
 
 // Set this so the sketch won't reset as the phone is rotated
 orientation(LANDSCAPE); // Note that this flips sw + sh
 
 // Setup Fonts
 fontList = PFont.list();
 //println(fontList);
 androidFont= createFont(fontList[4], ts, true); // Sans-Serif Bold
 textFont(androidFont);
 textMode(MODEL); // SCREEN substantially slows down sketch
  
} 

//-----------------------------------------------------------------------------------------

void draw() {
  
  background(55); // Dark Grey
  // println(frameRate);
  
  // Remap Accelerometer Values to Screen Values
  float Azimuth = acc_values[0];
  float mapX = map(Azimuth, 10, -10, 0, 480);
  float Pitch = acc_values[1];
  float mapY = map(Pitch, 10, -10, 0, 800);
  
  // Create our Bounding Boxes for the Text, and the offset to Center the Text with
  float fieldX = sw*0.9; // 720 on N1
  float offsetX = fieldX/2;
  float fieldY = sh*0.9; // 432 on N1
  float offsetY = fieldY/2;
  
  float textAzimuth = sw/2-mapY; // Y because of LANDSCAPE
  float textPitch = sh/2-mapX; // X because of LANDSCAPE  
  
  if (acc_values != null) {
   
   fill(155); // Light Gray
   text(msg, textAzimuth+ts/2, textPitch+ts/2, fieldX, fieldY); // Floating Text // offset by half of text size
   
   textAlign(CENTER, CENTER); // Center the Front Image
   fill(255); // White
   text(msg, sw/2-offsetX, sh/2-offsetY, fieldX, fieldY); // Static Text, centered
  
  }
  
}

//-----------------------------------------------------------------------------------------

void keyPressed() {
 if (key != CODED) {
  msg+=key;
 }
  
}

//-----------------------------------------------------------------------------------------

// Override the parent (super) Activity class:
// States onCreate(), onStart(), and onStop() aren't called by the sketch.  Processing is entered at
// the 'onResume()' state, and exits at the 'onPause()' state, so just override them:

void onResume() {
  super.onResume();
  println("RESUMED! (Sketch Entered...)");
  // Build our SensorManager:
  mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  // Build a SensorEventListener for each type of sensor:
  accSensorEventListener = new MySensorEventListener();
  // Get each of our Sensors:
  acc_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  // Register the SensorEventListeners with their Sensor, and their SensorManager:
  mSensorManager.registerListener(accSensorEventListener, acc_sensor, SensorManager.SENSOR_DELAY_GAME);
}

void onPause() {
  // Unregister all of our SensorEventListeners upon exit:
  mSensorManager.unregisterListener(accSensorEventListener);
  println("PAUSED! (Sketch Exited...)");
  super.onPause();
} 

//-----------------------------------------------------------------------------------------

// Setup our SensorEventListener
class MySensorEventListener implements SensorEventListener {
  void onSensorChanged(SensorEvent event) {
    int eventType = event.sensor.getType();
    if(eventType == Sensor.TYPE_ACCELEROMETER) {
      acc_values = event.values;
    }
  }
  void onAccuracyChanged(Sensor sensor, int accuracy) {
    // do nuthin'...
  }
}

