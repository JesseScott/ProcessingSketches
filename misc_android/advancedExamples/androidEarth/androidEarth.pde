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
import android.view.MotionEvent;

import toxi.geom.*;
import toxi.geom.Vec2D;
import toxi.geom.Vec3D;
import toxi.math.MathUtils;

// Declarations
LocationManager locationManager;
MyLocationListener locationListener;

SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
Sensor acc_sensor;
float[] acc_values;

int maxTouchEvents = 5;
MultiTouch[] mt;

float currentLatitude  = 0;
float currentLongitude = 0;
float currentAccuracy  = 0;
String currentProvider = "";
float lat, lon;

PShape globe, loc;
PImage texmap;
int sDetail = 32; 
int globeRadius = 175;
float zoom = 0;
float rotationY = 0;
float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5f;
int SINCOS_LENGTH = (int)(360.0f / SINCOS_PRECISION);  
boolean usingPShape = true;

void setup() {
  size(480, 800, P3D);
  orientation(PORTRAIT);

  texmap = loadImage("earth_4096.jpg");    
  initializeSphere(sDetail);
  autoNormal(false);  
  noStroke();
  globe = beginRecord();
    texturedSphere(globeRadius, texmap);
  endRecord();
  loc = beginRecord();
    sphere(2);
  endRecord();
  
  mt = new MultiTouch[maxTouchEvents];
  for(int i=0; i < maxTouchEvents; i++) {
    mt[i] = new MultiTouch();
  }
  
}

//------------------------------------------------

void draw() {
  background(0); 
  renderGlobe();
  
  if (mousePressed == true) {
    for(int i=0; i < maxTouchEvents; i++) {
      if(mt[1].touched == true) {
        zoom = dist( mt[0].motionX, mt[0].motionY, mt[1].motionX, mt[1].motionY ) - globeRadius;
      }
    }
  }
  
}

//------------------------------------------------

Vec2D gps;
Vec3D pos;

public void setLatLon() {
  gps = new Vec2D(currentLongitude, currentLatitude);
}

public Vec3D computePosOnSphere(int globeRadius) {
  pos = new Vec3D(globeRadius, MathUtils.radians(gps.x) + MathUtils.PI,MathUtils.radians(gps.y)).toCartesian();
  return pos;
}

public void callPos() {
  setLatLon();
  computePosOnSphere(globeRadius); 
}


