// Android Example for Weave Magazine 02.11
//
// androidAccel2Color.pde
// Shows the basic use of the Accelerometer
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
//
// With Code from Erik Pavey http://akeric.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

  // Imports
  import android.content.Context;
  import android.hardware.Sensor;
  import android.hardware.SensorEvent;
  import android.hardware.SensorManager;
  import android.hardware.SensorEventListener;
  
  // Declarations
  SensorManager mSensorManager;
  MySensorEventListener accSensorEventListener;
  Sensor acc_sensor;
  float[] acc_values;
  
//-----------------------------------------------------------------------------------------  
  
  void setup() {
    size(displayWidth, displayHeight, P3D);
    orientation(PORTRAIT);
    frameRate(30);
  }
  
//-----------------------------------------------------------------------------------------  
  
  void draw() {
    println(frameRate);
    if (acc_values != null) { 
      float Azimuth = map(acc_values[0], 10, -10, 0, 255);
      float Pitch = map(acc_values[1], 10, -10, 0, 255);
      float Roll = map(acc_values[2], 10, -10, 0, 255);
      fill(Azimuth, Pitch, Roll); 
      rect(0, 0, width, height);
    }
  }
  
//-----------------------------------------------------------------------------------------  
  
  void onResume() {
    super.onResume();
    mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
    accSensorEventListener = new MySensorEventListener();
    acc_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    mSensorManager.registerListener(accSensorEventListener, acc_sensor, SensorManager.SENSOR_DELAY_GAME);
  } 
  
//-----------------------------------------------------------------------------------------  
  
  void onPause() {
    mSensorManager.unregisterListener(accSensorEventListener);
    super.onPause();
  } 
  
//-----------------------------------------------------------------------------------------  

  class MySensorEventListener implements SensorEventListener {
    void onSensorChanged(SensorEvent event) {
      int eventType = event.sensor.getType();
      if(eventType == Sensor.TYPE_ACCELEROMETER) {
        acc_values = event.values;
      }
    }
    void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
  }

