//
//Set Sketch Permissions : ACCESS_COURSE_LOCATION, ACCESS_FINE_LOCATION
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0194)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

// Imports
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.GpsStatus.Listener;
import android.location.GpsStatus.NmeaListener;
import android.os.Bundle;

String[] fontList;
PFont androidFont;

LocationManager locationManager;
MyLocationListener locationListener;

// Variables to hold the current GPS data
float currentLatitude  = 0;
float currentLongitude = 0;
float currentAltitude = 0;
float currentBearing = 0;
float currentSpeed = 0;
float currentAccuracy  = 0;
String currentProvider = "";

//-----------------------------------------------------------------------------------------

void setup() {
  size(displayWidth, displayHeight);
  orientation(PORTRAIT);
  background(0);
  fontList = PFont.list();
  androidFont = createFont(fontList[4], 25, true);
  textFont(androidFont);
}

//-----------------------------------------------------------------------------------------

void draw() {
  background(0);
  // Display current GPS data
  text("Latitude: " +currentLatitude, 20, 40);
  text("Longitude: " +currentLongitude, 20, 80);
  text("Altitude: " +currentAltitude, 20, 120);
  text("Bearing: " +currentBearing, 20, 160);
  text("Speed: " +currentSpeed, 20, 200);
  text("Accuracy: " +currentAccuracy, 20, 240);
  text("Provider: " +currentProvider, 20, 285);  
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
      currentAltitude = (float)location.getAltitude();
      currentBearing = (float)location.getBearing();
      currentSpeed = (float)location.getSpeed();
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


