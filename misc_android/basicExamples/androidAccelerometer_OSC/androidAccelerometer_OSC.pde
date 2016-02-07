
//-----------------------------------------------------------------------------------------
// Imports required for sensor usage:
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;

// OSCP5
//import oscP5.*;
//import netP5.*;

//-----------------------------------------------------------------------------------------
// Screen Data:
float sw, sh;
// Font Data:
String[] fontList;
PFont androidFont;
int text_size = 45;

// Setup variables for the SensorManager, the SensorEventListeners,
// the Sensors, and the arrays to hold the resultant sensor values:
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;

// OSC
OscP5 oscP5;
NetAddress myRemoteLocation;

//-----------------------------------------------------------------------------------------

void setup() {
  size(screenWidth, screenHeight, A2D);
  sw = screenWidth; // 480.0 on Nexus One
  sh = screenHeight; // 800.0 on Nexus One
  // Set this so the sketch won't reset as the phone is rotated:
  orientation(PORTRAIT);
  // Setup Fonts:
  fontList = PFont.list();
  androidFont = createFont(fontList[0], text_size, true);
  textFont(androidFont);
  // OSCP5
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("192.168.2.103",12000);
}

//-----------------------------------------------------------------------------------------

void draw() {
  fill(0);
  rect(0,0,sw,sh);
  fill(255);
  noStroke();
  
  // Remap our Accelerometer Values to Screen Values
  float Azimuth = acc_values[0];
  float mapX = map(Azimuth, 10, -10, 0, 480);
  float Pitch = acc_values[1];
  float mapY = map(Pitch, -10, 10, 0, 800);
  
  // Draw our X and Y depending upon the Accelerometer
  if (acc_values != null) {  
    text(" X " + acc_values[0], mapX - text_size, sh/2, 80, 80);
    text(" Y " + acc_values[1], sw/2 - text_size, mapY, 80, 80); 
    oscP5.send("/android",new Object[] {new Float(acc_values[0]), new Float(acc_values[1]), new Float(acc_values[2])}, myRemoteLocation);
  }
  else  {
   text("Accelerometer: null", 8, 20);
  }
  
}

//-----------------------------------------------------------------------------------------
// Override the parent (super) Activity class:

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
    // do nothin...
  }
}
