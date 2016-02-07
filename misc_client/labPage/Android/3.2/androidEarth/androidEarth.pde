// Earth
// by Mike 'Flux' Chang (cleaned up by Aaron Koblin). 
// Based on code by Toxi. 
// Android port by Andres Colubri.
// Expanded by Jesse Scott.


// Imports
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
  size(480, 800, A3D);
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
float degreesToRadians(float d) {
  return((d/180) * PI);
};


//2. Function to convert a lat/lon vector into a radial vector
Vec2D toRadians(float lat, float lon) {
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
Vec3D latToSphere(Vec2D ll, float r) {
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
Vec3D sphereToCart(Vec3D ll) {
  println("4.A : LL at start of sphereToCart " + ll.x + " " + ll.y + " " + ll.z); // IS IT BEING PASSED PROPERLY ???
  Vec3D v = new Vec3D();
  v.x = ll.z * cos(ll.y) * sin(ll.x);
  v.y = ll.z * sin(ll.y) * sin(ll.x);
  v.z = ll.z  * cos(ll.x);
  println("4.B : LL into CARTESIAN " + v.x + " " + v.y + " " + v.z);
  return(v); 
 
};


