package processing.android.test.androidearth;

import processing.core.*; 
import processing.xml.*; 

import android.content.Context; 
import android.hardware.Sensor; 
import android.hardware.SensorEvent; 
import android.hardware.SensorManager; 
import android.hardware.SensorEventListener; 
import android.location.Location; 
import android.location.LocationManager; 
import android.location.LocationListener; 
import android.location.GpsStatus.Listener; 
import android.location.GpsStatus.NmeaListener; 
import android.os.Bundle; 

import toxi.physics.constraints.*; 
import toxi.math.conversion.*; 
import toxi.geom.*; 
import toxi.math.*; 
import toxi.geom.mesh2d.*; 
import toxi.physics2d.constraints.*; 
import toxi.physics.*; 
import toxi.util.datatypes.*; 
import toxi.util.events.*; 
import toxi.geom.mesh.subdiv.*; 
import toxi.physics2d.behaviors.*; 
import toxi.physics2d.*; 
import toxi.geom.mesh.*; 
import toxi.math.waves.*; 
import toxi.physics.behaviors.*; 
import toxi.util.*; 
import toxi.math.noise.*; 

import android.view.MotionEvent; 
import android.view.KeyEvent; 
import android.graphics.Bitmap; 
import java.io.*; 
import java.util.*; 

public class androidEarth extends PApplet {

// Earth
// by Mike 'Flux' Chang (cleaned up by Aaron Koblin). 
// Based on code by Toxi. 
// Android port by Andres Colubri.
// Expanded by Jesse Scott.


// Imports












// Declarations
LocationManager locationManager;
MyLocationListener locationListener;

SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;

float currentLatitude  = 0;
float currentLongitude = 0;
float currentAccuracy  = 0;
String currentProvider = "";
float lat, lon;

PShape globe;
PImage texmap;
int pulse = 0;
int sDetail = 32;  // Sphere detail setting
float globeRadius = 400;
float pushBack = 0;
float rotationY = 0;
float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5f;
int SINCOS_LENGTH = (int)(360.0f / SINCOS_PRECISION);  
boolean usingPShape = true;

public void setup() {
 
  orientation(PORTRAIT);

  texmap = loadImage("world32k.jpg");    
  initializeSphere(sDetail);

  autoNormal(false);  
  noStroke();

  globe = beginRecord();
  texturedSphere(globeRadius, texmap);
  endRecord();
}

public void draw() {
  background(0); 
  renderGlobe();
  pulse++;
  if(pulse > 255) pulse = 0;
  //int fps = round(frameRate); println(fps);
  
}

//------------------------------------------------

//1. Function to convert degrees to radians
public float degreesToRadians(float d) {
  return((d/180) * PI);
};


//2. Function to convert a lat/lon vector into a radial vector
public Vec2D toRadians(float lat, float lon) {
    Vec2D r = new Vec2D();
    lat = currentLatitude;
    lon = currentLongitude;
    println("2.A : LATLON into Radians " + lat + " " + lon);
    //LON
    r.y = degreesToRadians(-lon) - PI/2;
    //LAT (Parallels)
    r.x = degreesToRadians(-lat) + PI/2;
    println("2.B : RADIANS from LatLon " + r.x + " " + r.y);
    return(r);

  };

//3. Function to convert a lat/lon vector into a 3D spherical coordinate vector
public Vec3D latToSphere(Vec2D ll, float r) {
   println("3.A : LL at start of latToSphere " + ll); // IS IT BEING PASSED PROPERLY ???
   Vec3D v = new Vec3D();
   ll = toRadians(ll.x, ll.y);
   println("3.B : LL after Radians " + ll.x + " " + ll.y); // IS IT BEING PASSED PROPERLY ???
   v.x = ll.x;
   v.y = ll.y - PI/2;
   v.z = r;
   println("3.C : LL into SPHERICAL " + v.x + " " + v.y + " " + v.z);
   return(v);    
};

//4. Function to convert a 3D spherical coordinate vector into a 3D cartesian vector (X,Y,Z)
public Vec3D sphereToCart(Vec3D ll) {
  println("4.A : LL at start of sphereToCart " + ll.x + " " + ll.y + " " + ll.z); // IS IT BEING PASSED PROPERLY ???
  Vec3D v = new Vec3D();
  v.x = ll.z * cos(ll.y) * sin(ll.x);
  v.y = ll.z * sin(ll.y) * sin(ll.x);
  v.z = ll.z  * cos(ll.x);
  println("4.B : LL into CARTESIAN " + v.x + " " + v.y + " " + v.z);
  return(v); 
 
};



//-----------------------------------------------------------------------------------------
  
public void onResume() {
  super.onResume();
  // Accelerometer
  mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  accSensorEventListener = new MySensorEventListener();
  acc_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  mSensorManager.registerListener(accSensorEventListener, acc_sensor, SensorManager.SENSOR_DELAY_GAME);
  // GPS
  locationListener = new MyLocationListener();
  locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);    
  locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListener);

}

public void onPause() {
  // Unregister all of our SensorEventListeners upon exit:
  mSensorManager.unregisterListener(accSensorEventListener);
  super.onPause();
} 
  
//-----------------------------------------------------------------------------------------

// Setup our SensorEventListener
class MySensorEventListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    int eventType = event.sensor.getType();
    if(eventType == Sensor.TYPE_ACCELEROMETER) {
      acc_values = event.values;
    }
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
    // do nothin...
  }
}

//-----------------------------------------------------------------------------------------

 //Class for capturing the GPS data
class MyLocationListener implements LocationListener {
  // Define all LocationListener methods
  public void onLocationChanged(Location location) {
    // Save new GPS data
    currentLatitude  = (float)location.getLatitude();
    currentLongitude = (float)location.getLongitude();
    currentAccuracy  = (float)location.getAccuracy();
    currentProvider  = location.getProvider();
  }

  public void onProviderDisabled (String provider) { 
    currentProvider = "";
  }

  public void onProviderEnabled (String provider) { 
    currentProvider = provider;
  }

  public void onStatusChanged (String provider, int status, Bundle extras) {
    // Nothing yet...
  }
}
//-----------------------------------------------------------------------------------------

public void renderGlobe() {
  pushMatrix();
    translate(width/2.0f, height/2.0f, pushBack);
    lights();   
   
    Vec2D latLon = new Vec2D();
    latLon.x = currentLatitude;
    latLon.y = currentLongitude;
    Vec3D spherePos = new Vec3D();
    Vec3D cartPos = new Vec3D();
    spherePos = latToSphere(latLon, globeRadius);
    println("Ra : Lat & Lon after spherePos " + latLon);
    cartPos = sphereToCart(spherePos); 
    println("Rb : final SPHERE " + spherePos); // SPHERE {x:0.65439385, y:-3.3764088, z:400.0}
    println("Rc : final CART " + cartPos); // CART {x:-236.78981, y:56.64707, z:317.36682}
    
    float Azimuth = acc_values[0]/2;
    float Pitch = acc_values[1]/8;
    
      pushMatrix();
        rotateX(Pitch/3 * PI);
        rotateY(Azimuth/3 * PI);
        //rotateY(0);

        //rotateY(rotationY);
        if (usingPShape) {
          shape(globe);
          
          pushMatrix();
          //translate(latLon.x, latLon.y, globeRadius);
          stroke(255, 100, 0);
          strokeWeight(5);
          line(spherePos.x, spherePos.y, spherePos.x * globeRadius, spherePos.y * globeRadius);
          //line(0, 0, cartPos.x * globeRadius, cartPos.y * globeRadius);
          //point(spherePos.x * globeRadius, spherePos.y * globeRadius);
          popMatrix();
  
        } else {
          texturedSphere(globeRadius, texmap);

        } 
      popMatrix();  
  popMatrix();
  rotationY += 0.01f;
  

  
}

public void initializeSphere(int res) {
  sinLUT = new float[SINCOS_LENGTH];
  cosLUT = new float[SINCOS_LENGTH];

  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
  }

  float delta = (float)SINCOS_LENGTH/res;
  float[] cx = new float[res];
  float[] cz = new float[res];

  // Calc unit circle in XZ plane
  for (int i = 0; i < res; i++) {
    cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
    cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
  }

  // Computing vertexlist vertexlist starts at south pole
  int vertCount = res * (res-1) + 2;
  int currVert = 0;

  // Re-init arrays to store vertices
  sphereX = new float[vertCount];
  sphereY = new float[vertCount];
  sphereZ = new float[vertCount];
  float angle_step = (SINCOS_LENGTH*0.5f)/res;
  float angle = angle_step;

  // Step along Y axis
  for (int i = 1; i < res; i++) {
    float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
    float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
    for (int j = 0; j < res; j++) {
      sphereX[currVert] = cx[j] * curradius;
      sphereY[currVert] = currY;
      sphereZ[currVert++] = cz[j] * curradius;
    }
    angle += angle_step;
  }
  sDetail = res;
}

// Generic routine to draw textured sphere
public void texturedSphere(float r, PImage t) {
  int v1,v11,v2;
  r = (r + 240 ) * 0.33f;
  beginShape(TRIANGLE_STRIP);
  texture(t);
  float iu=(float)(t.width-1)/(sDetail);
  float iv=(float)(t.height-1)/(sDetail);
  float u=0,v=iv;
  for (int i = 0; i < sDetail; i++) {
    normal(0, -1, 0);
    vertex(0, -r, 0,u,0);
    normal(sphereX[i], sphereY[i], sphereZ[i]);
    vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
    u+=iu;
  }
  vertex(0, -r, 0,u,0);
  normal(sphereX[0], sphereY[0], sphereZ[0]);
  vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
  endShape();   
  
  // Middle rings
  int voff = 0;
  for(int i = 2; i < sDetail; i++) {
    v1=v11=voff;
    voff += sDetail;
    v2=voff;
    u=0;
    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int j = 0; j < sDetail; j++) {
      normal(sphereX[v1], sphereY[v1], sphereZ[v1]);
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
      normal(sphereX[v2], sphereY[v2], sphereZ[v2]);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
      u+=iu;
    }
  
    // Close each ring
    v1=v11;
    v2=voff;
    normal(sphereX[v1], sphereY[v1], sphereZ[v1]);
    vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
    normal(sphereX[v2], sphereY[v2], sphereZ[v2]);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
    endShape();
    v+=iv;
  }
  u=0;
  
  // Add the northern cap
  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i = 0; i < sDetail; i++) {
    v2 = voff + i;
    normal(sphereX[v2], sphereY[v2], sphereZ[v2]);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
    normal(0, 1, 0);
    vertex(0, r, 0, u, v+iv); 
    u+=iu;
  }
  normal(sphereX[voff], sphereY[voff], sphereZ[voff]);
  vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);

  endShape(); 
}

  public int sketchWidth() { return 480; }
  public int sketchHeight() { return 800; }
  public String sketchRenderer() { return A3D; }
}
