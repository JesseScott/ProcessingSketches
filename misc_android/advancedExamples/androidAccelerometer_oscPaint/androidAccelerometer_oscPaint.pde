
//-----------------------------------------------------------------------------------------
// Imports required for sensor usage:
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;


//-----------------------------------------------------------------------------------------
// Screen Data:
int picker;
int touch = 0;

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

  colorMode(HSB, 480);
  for (int i = 0; i < 480; i++) {
    for (int j = 0; j < 480; j++) {
      stroke(i, j, (i+j) / 2);
      point(i, j);
    }
  }
  
  // Set this so the sketch won't reset as the phone is rotated:
  orientation(PORTRAIT);

  // OSCP5
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("192.168.2.103",12000);
}

//-----------------------------------------------------------------------------------------

void draw() {
  if(mouseY < 481) {
    picker = get(mouseX, mouseY);
  }

  noStroke();
  fill(picker);
  rect(0, 480, 480, 320);

  noFill();
  strokeWeight(5);
  stroke(0);
  rect(0, 480, 480, 320);
  
  oscP5.send("/andColor",new Object[] {new Integer(picker)}, myRemoteLocation);

  if (acc_values != null) {  
    oscP5.send("/andAcc",new Object[] {new Float(acc_values[0]), new Float(acc_values[1]), new Float(acc_values[2])}, myRemoteLocation);
  }
  
  if (mousePressed == true) {
    touch = 1; 
  } else {
    touch = 0;
  }
  oscP5.send("/andPress",new Object[] {new Integer(touch)}, myRemoteLocation);
  
}



//-----------------------------------------------------------------------------------------
// Override the parent (super) Activity class:

void onResume() {
  super.onResume();
  println("RESUMED! (Sketch Entered...)");
  mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  accSensorEventListener = new MySensorEventListener();
  acc_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  mSensorManager.registerListener(accSensorEventListener, acc_sensor, SensorManager.SENSOR_DELAY_GAME);
}

void onPause() {
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
