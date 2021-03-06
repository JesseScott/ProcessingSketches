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
  rotationY += 0.01;
  

  
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
void texturedSphere(float r, PImage t) {
  int v1,v11,v2;
  r = (r + 240 ) * 0.33;
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
