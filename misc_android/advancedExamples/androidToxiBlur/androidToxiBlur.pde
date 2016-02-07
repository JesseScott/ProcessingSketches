// Android Example for Weave Magazine 02.11
//
// androidToxiBlur.pde
// Shows the basic use of Blur from Toxi Library
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
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
import toxi.math.*;
import toxi.color.*;

// Declarations
float sw, sh;
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;

//-----------------------------------------------------------------------------------------

void setup() {
  size(screenWidth,screenHeight, A2D);
  orientation(LANDSCAPE);
}

//-----------------------------------------------------------------------------------------

void draw() {
  println(frameRate);
  float X = map(acc_values[1], 10, -10, 0, 800);
  ColorGradient grad=new ColorGradient();
  println(frameRate);
  // use alternative interpolation function when mouse is pressed
  if (acc_values != null) {
    grad.setInterpolator(new CosineInterpolation());
  }
  grad.addColorAt(0,TColor.BLACK);
  grad.addColorAt(width,TColor.BLUE);
  grad.addColorAt(X,TColor.RED);
  grad.addColorAt(width-X,TColor.YELLOW);
  ColorList l=grad.calcGradient(0,width);
  int x=0;
  for(Iterator i=l.iterator(); i.hasNext();) {
    TColor c=(TColor)i.next();
    stroke(c.toARGB());
    line(x,0,x,height);
    x++;
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

void onPause() {
  mSensorManager.unregisterListener(accSensorEventListener);
  super.onPause();
} 

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
