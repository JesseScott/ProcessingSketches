
// ---------------------------------

Vec2D gps;
Vec3D pos;

public void setLatLon() {
  // set to Berlin
  gps = new Vec2D(13.3978, 52.5329);

}

public Vec3D computePosOnSphere(int globeRadius) {
  pos = new Vec3D(globeRadius, MathUtils.radians(gps.x) + MathUtils.PI,MathUtils.radians(gps.y)).toCartesian();
  return pos;
}

public void callPos() {
  setLatLon();
  computePosOnSphere(globeRadius); 
}

// ---------------------------------
