// Imports
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.GpsStatus.Listener;
import android.location.GpsStatus.NmeaListener;
import android.os.Bundle;

// Declarations
LocationManager locationManager;
MyLocationListener locationListener;

float currentLatitude  = 0;
float currentLongitude = 0;
float currentAccuracy  = 0;
String currentProvider = "";

WorldMap wmap;
Point[] cities;
int pulse = 0;

void setup() {
  size(800, 480);
  background(255);
  orientation(LANDSCAPE);
  ellipseMode(CENTER);
  smooth();

  wmap = new WorldMap();


}

void draw() {
  pulse++;
  if(pulse > 255) {
    pulse = 0;
  }
  cities = new Point[] {
   wmap.getPoint(currentLatitude, currentLongitude)    // Berlin
  };
  wmap.drawBackground();
  strokeWeight(1.5);
  stroke(pulse);
  fill(pulse, 150, 0);
  for (int i = 0; i < cities.length; i++) {
    ellipse(cities[i].x, cities[i].y, 12, 12);
  }

}

//-----------------------------------------------------------------------------------------

class WorldMap {
  
  int x, y, w, h;
  PImage raster;

   WorldMap() {
     this(0, 0, width, height);
   }

   WorldMap(int x, int y, int w, int h) {
   if (h >= w/2) {
     this.w = w;
     this.h = w/2;
     this.x = x;
     this.y = (h - this.h)/2;
   } else {
     this.h = h;
     this.w = 2*h;
     this.x = (w - this.w)/2;
     this.y = y;
   }
   raster = loadImage("world_longlatwgs3.png");
  }

 void drawBackground() {
   image(raster, x, y, w, h);
  }

 Point getPoint(float phi, float lambda) {
   return new Point(
     x + ((180+lambda)/360)*w,
     y + h - ((90+phi)/180)*h
   );
  }

}

class Point extends Point2D {
  Point(float x, float y) { super(x, y); }
  }

class Point2D {
  float x, y;
  Point2D(float x, float y) {
    this.x = x; this.y = y;
  }
}

//-----------------------------------------------------------------------------------------

void onResume() {
  super.onResume();
  // Build Listener
  locationListener = new MyLocationListener();
  // Acquire a reference to the system Location Manager
  locationManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
  // Register the listener with the Location Manager to receive location updates
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);
}

void onPause() {
  super.onPause();
}

//-----------------------------------------------------------------------------------------

// Define a listener that responds to location updates
class MyLocationListener implements LocationListener {
   void onLocationChanged(Location location) {
      // Called when a new location is found by the network location provider.
      currentLatitude  = (float)location.getLatitude();
      currentLongitude = (float)location.getLongitude();
      currentAccuracy  = (float)location.getAccuracy();
      currentProvider  = location.getProvider();
    }
    void onProviderDisabled (String provider) { 
      currentProvider = "";
    }

    void onProviderEnabled (String provider) { 
      currentProvider = provider;
    }

    void onStatusChanged (String provider, int status, Bundle extras) {
      // Nothing yet...
    }
    
}


