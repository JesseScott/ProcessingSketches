
// Imports
import edu.uic.ketai.*;
import edu.uic.ketai.inputService.KetaiCamera;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;

// Declarations
Ketai ketai;
KetaiCamera cam;
long dataCount;
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;
PImage tex;
PImage vid;

//-----------------------------------------------------------------------------------------

void setup() {
  // Screen
  size(screenWidth, screenHeight, A3D); // 800 x 480 on Nexus One
  hint(ENABLE_OPENGL_4X_SMOOTH);
  orientation(LANDSCAPE);
  background(0);
  smooth();
  tex = loadImage("icon-72.png");
  //Create Ketai object
  ketai = new Ketai(this);
  ketai.setCameraParameters(320, 240, 10);
  ketai.enableCamera();
  dataCount = ketai.getDataCount();
  ketai.startCollectingData();
  PImage vid = cam;
}

//-----------------------------------------------------------------------------------------

void draw() {

  background(0); 
    float Azimuth = acc_values[0]/3;
    float Pitch = acc_values[1]/3;
    float Roll = acc_values[2]/3;

    if (acc_values != null) {    
      translate(width/2, height/2, 0);
      pushMatrix();
      rotateY(Pitch/2 * PI);
      rotateX(Azimuth/2 * PI);
      rotateZ(Roll/2 * PI);

      scale(90);
      beginShape(QUADS);
      stroke(255);
      texture(tex);
      
       vertex(-1,  1,  1, 0, 0);
       vertex( 1,  1,  1, 0, 72);
       vertex( 1, -1,  1, 72, 72);
       vertex(-1, -1,  1, 72, 0);
  
       vertex( 1,  1,  1, 0, 0);
       vertex( 1,  1, -1, 0, 72);
       vertex( 1, -1, -1, 72, 72);
       vertex( 1, -1,  1, 72, 0);
      
       vertex( 1,  1, -1, 0, 0);
       vertex(-1,  1, -1, 0, 72);
       vertex(-1, -1, -1, 72, 72);
       vertex( 1, -1, -1, 72, 0);
      
       vertex(-1,  1, -1, 0, 0);
       vertex(-1,  1,  1, 0, 72);
       vertex(-1, -1,  1, 72, 72);
       vertex(-1, -1, -1, 72, 0);
        
       vertex(-1,  1, -1, 0, 0);
       vertex( 1,  1, -1, 0, 72);
       vertex( 1,  1,  1, 72, 72);
       vertex(-1,  1,  1, 72, 0);
      
       vertex(-1, -1, -1, 0, 0);
       vertex( 1, -1, -1, 0, 72);
       vertex( 1, -1,  1, 72, 72);
       vertex(-1, -1,  1, 72, 0); 
       
      endShape();

      popMatrix();   
    }
  
}

//-----------------------------------------------------------------------------------------

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

void onCameraPreviewEvent(KetaiCamera cam) {
  cam.read();
  image(cam, 0, 0, cam.width*2, cam.height*2);
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

