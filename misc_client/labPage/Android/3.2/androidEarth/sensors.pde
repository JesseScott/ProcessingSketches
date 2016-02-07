
//-----------------------------------------------------------------------------------------
  
void onResume() {
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

void onPause() {
  // Unregister all of our SensorEventListeners upon exit:
  mSensorManager.unregisterListener(accSensorEventListener);
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

//-----------------------------------------------------------------------------------------

 //Class for capturing the GPS data
class MyLocationListener implements LocationListener {
  // Define all LocationListener methods
  void onLocationChanged(Location location) {
    // Save new GPS data
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
