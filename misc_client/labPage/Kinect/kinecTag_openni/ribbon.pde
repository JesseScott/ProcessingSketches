
//----------------------------------------

class Ribbon {
  int ribbonAmount;
  float randomness;
  int id;
  int ribbonParticleAmount;         // length of the Particle Array (max number of points)
  int particlesAssigned = 0;        // current amount of particles currently in the Particle array                                
  float radiusMax = 12;             // maximum width of ribbon
  float radiusDivide = 10;          // distance between current and next point / this = radius for first half of the ribbon
  float gravity = .07;              // gravity applied to each particle
  float friction = 1.1;             // friction applied to the gravity of each particle
  int maxDistance = 40;             // if the distance between particles is larger than this the drag comes into effect
  float drag = 2.5;                 // if distance goes above maxDistance - the points begin to grag. high numbers = less drag
  float dragFlare = .015;           // degree to which the drag makes the ribbon flare out
  RibbonParticle[] particles;       // particle array
  color ribbonColor;
  
  Ribbon(int ribbonParticleAmount, color ribbonColor, float randomness, int id) {
    this.ribbonParticleAmount = ribbonParticleAmount;
    this.ribbonColor = ribbonColor;
    this.randomness = randomness;
    this.id = ribbonCounter;
    init();
  }
  
  void init() {
    particles = new RibbonParticle[ribbonParticleAmount];
  }
  
  void update(float randX, float randY) {
    addParticle(randX, randY);
    drawCurve();
  }
  
  void addParticle(float randX, float randY) {
    if(particlesAssigned == ribbonParticleAmount) {
      for (int i = 1; i < ribbonParticleAmount; i++) {
        particles[i-1] = particles[i];
      }
      particles[ribbonParticleAmount - 1] = new RibbonParticle(randomness, this);
      particles[ribbonParticleAmount - 1].px = randX;
      particles[ribbonParticleAmount - 1].py = randY;
      return;
    }
    else {
      particles[particlesAssigned] = new RibbonParticle(randomness, this);
      particles[particlesAssigned].px = randX;
      particles[particlesAssigned].py = randY;
      ++particlesAssigned;
    }
    if (particlesAssigned > ribbonParticleAmount) ++particlesAssigned;
  }
  
  void drawCurve() {
    for (int i = 1; i < particlesAssigned - 1; i++) {
      RibbonParticle p = particles[i];
      p.calculateParticles(particles[i-1], particles[i+1], ribbonParticleAmount, i);
    }

    for (int i = particlesAssigned - 3; i > 1 - 1; i--) {
      RibbonParticle p = particles[i];
      RibbonParticle pm1 = particles[i-1];
      natzke.fill(ribbonColor, ribbonAlpha);
      natzke.stroke(ribbonColor, ribbonAlpha);
      if (i < particlesAssigned-3) {
        natzke.beginShape();
        natzke.vertex(p.lcx2, p.lcy2);
        natzke.bezierVertex(p.leftPX, p.leftPY, pm1.lcx2, pm1.lcy2, pm1.lcx2, pm1.lcy2);
        natzke.vertex(pm1.rcx2, pm1.rcy2);
        natzke.bezierVertex(p.rightPX, p.rightPY, p.rcx2, p.rcy2, p.rcx2, p.rcy2);
        natzke.vertex(p.lcx2, p.lcy2);
        natzke.endShape();
      }
    }
  }
}

//----------------------------------------

class RibbonManager {
  PImage img;
  int ribbonAmount;
  int ribbonParticleAmount;
  float randomness;
  int id;
  String imgName;
  Ribbon[] ribbons;  
  
  RibbonManager(int ribbonAmount, int ribbonParticleAmount, float randomness, int id) {
    this.ribbonAmount = ribbonAmount;
    this.ribbonParticleAmount = ribbonParticleAmount;
    this.randomness = randomness;
    this.id = ribbonCounter;
    init();
  }
  
  void init() {
    addRibbon();
  }

  void addRibbon() {
    ribbons = new Ribbon[ribbonAmount];
    for (int i = 0; i < ribbonAmount; i++) {  
      color ribbonColor = color(255, 155, 55);
      ribbons[i] = new Ribbon(ribbonParticleAmount, ribbonColor, randomness, ribbonCounter);
    }
  }
  
  void update(float currX, float currY) {
    for (int i = 0; i < ribbonAmount; i++) {
      //float randX = currX + (randomness / 2) - random(randomness);
      //float randY = currY + (randomness / 2) - random(randomness); 
      float randX = currX;
      float randY = currY;

      ribbons[i].update(randX, randY);
    }
  }
  
  void setRadiusMax(float value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].radiusMax = value; } }
  void setRadiusDivide(float value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].radiusDivide = value; } }
  void setGravity(float value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].gravity = value; } }
  void setFriction(float value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].friction = value; } }
  void setMaxDistance(int value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].maxDistance = value; } }
  void setDrag(float value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].drag = value; } }
  void setDragFlare(float value) { for (int i = 0; i < ribbonAmount; i++) { ribbons[i].dragFlare = value; } }
}

//----------------------------------------

class RibbonParticle {
  float px, py;                             // xy position of particle (this is the bexier point)
  float xSpeed, ySpeed = 0;                 // speed of the xy positions
  float cx1, cy1, cx2, cy2;                 // average xy positions between px/py & points of the surrounding Particles
  float leftPX, leftPY, rightPX, rightPY;   // xy points of that determine the thickness of this segment
  float lpx, lpy, rpx, rpy;                 // xy points of the outer bezier points
  float lcx1, lcx2 = screenPos.x; 
  float lcy1, lcy2 = screenPos.y;            
  float rcx1, rcx2 = screenPos.x; 
  float rcy1, rcy2 = screenPos.y;
  float radius;                             // thickness of current particle
  float randomness;
  Ribbon ribbon;

  
  RibbonParticle(float randomness, Ribbon ribbon) {
    this.randomness = randomness;
    this.ribbon = ribbon;
  }
  
  void calculateParticles(RibbonParticle pMinus1, RibbonParticle pPlus1, int particleMax, int i) {
    float div = 2;
    cx1 = (pMinus1.px + px) / div;
    cy1 = (pMinus1.py + py) / div;
    cx2 = (pPlus1.px + px) / div;
    cy2 = (pPlus1.py + py) / div;

    // calculate radians (direction of next point)
    float dx = cx2 - cx1;
    float dy = cy2 - cy1;

    float pRadians = atan2(dy, dx);

    float distance = sqrt(dx*dx + dy*dy);

    if (distance > ribbon.maxDistance) {  //  && i > 1  {
      float oldX = px;
      float oldY = py;
      px = px + ((ribbon.maxDistance/ribbon.drag) * cos(pRadians));
      py = py + ((ribbon.maxDistance/ribbon.drag) * sin(pRadians));
      xSpeed += (px - oldX) * ribbon.dragFlare;
      ySpeed += (py - oldY) * ribbon.dragFlare;
    }
    
    ySpeed += ribbon.gravity;
    xSpeed *= ribbon.friction;
    ySpeed *= ribbon.friction;
    px += xSpeed + random(.3);
    py += ySpeed + random(.3);
    
    float randX = ((randomness / 2) - random(randomness)) * distance;
    float randY = ((randomness / 2) - random(randomness)) * distance;
    px += randX;
    py += randY;
    
    //float radius = distance / 2;
    //if (radius > radiusMax) radius = ribbon.radiusMax;
    
    if (i > particleMax / 2) {
      radius = distance / ribbon.radiusDivide;
    } 
    else {
      radius = pPlus1.radius * .9;
    }
    
    if (radius > ribbon.radiusMax) radius = ribbon.radiusMax;
    if (i == particleMax - 2 || i == 1) {
      if (radius > 1) radius = 1;
    }

    // calculate the positions of the particles relating to thickness
    leftPX = px + cos(pRadians + (HALF_PI * 3)) * radius;
    leftPY = py + sin(pRadians + (HALF_PI * 3)) * radius;
    rightPX = px + cos(pRadians + HALF_PI) * radius;
    rightPY = py + sin(pRadians + HALF_PI) * radius;

    // left and right points of current particle
    lpx = (pMinus1.lpx + lpx) / div;
    lpy = (pMinus1.lpy + lpy) / div;
    rpx = (pPlus1.rpx + rpx) / div;
    rpy = (pPlus1.rpy + rpy) / div;

    // left and right points of previous particle
    lcx1 = (pMinus1.leftPX + leftPX) / div;
    lcy1 = (pMinus1.leftPY + leftPY) / div;
    rcx1 = (pMinus1.rightPX + rightPX) / div;
    rcy1 = (pMinus1.rightPY + rightPY) / div;

    // left and right points of next particle
    lcx2 = (pPlus1.leftPX + leftPX) / div;
    lcy2 = (pPlus1.leftPY + leftPY) / div;
    rcx2 = (pPlus1.rightPX + rightPX) / div;
    rcy2 = (pPlus1.rightPY + rightPY) / div;
    
  }
}
