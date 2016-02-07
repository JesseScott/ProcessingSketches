


// Imports
import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.hardware.Camera.PreviewCallback;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.Surface;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;

// Declarations
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;
CameraSurfaceView gCamSurfView;
PImage gBuffer;

//-----------------------------------------------------------------------------------------

void setup() {
  size(screenWidth, screenHeight, A3D); // 800 x 480 on Nexus One
  orientation(LANDSCAPE);
  background(0);
  smooth();
  strokeWeight(3);
  stroke(255, 155);
}

//-----------------------------------------------------------------------------------------

void draw() {
  println(frameRate);
  background(0); 
    float Azimuth = acc_values[0];
    float Pitch = acc_values[1];
    float Roll = acc_values[2];

    if (acc_values != null) {    
      translate(width/2, height/2, 0);
      pushMatrix();
      rotateY(Pitch/2 * PI);
      rotateX(Azimuth/2 * PI);
      rotateZ(Roll/2 * PI);

      scale(90);
      beginShape(QUADS);
      //tint(55,155,255);
      texture(gBuffer);

      
       vertex(-1,  1,  1);
       vertex( 1,  1,  1);
       vertex( 1, -1,  1);
       vertex(-1, -1,  1);
  
       vertex( 1,  1,  1);
       vertex( 1,  1, -1);
       vertex( 1, -1, -1);
       vertex( 1, -1,  1);
      
       vertex( 1,  1, -1);
       vertex(-1,  1, -1);
       vertex(-1, -1, -1);
       vertex( 1, -1, -1);
      
       vertex(-1,  1, -1);
       vertex(-1,  1,  1);
       vertex(-1, -1,  1);
       vertex(-1, -1, -1);
      
       vertex(-1,  1, -1);
       vertex( 1,  1, -1);
       vertex( 1,  1,  1);
       vertex(-1,  1,  1);
      
       vertex(-1, -1, -1);
       vertex( 1, -1, -1);
       vertex( 1, -1,  1);
       vertex(-1, -1,  1); 
       
      endShape();

      popMatrix();   
    }
  
}

//-----------------------------------------------------------------------------------------

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
  // Create our 'CameraSurfaceView' objects, that works the magic:
  gCamSurfView = new CameraSurfaceView(this.getApplicationContext());
}


