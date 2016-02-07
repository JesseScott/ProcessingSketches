
void drawNatzke() {
  PVector v1 = tracker.getPos();
  natzke.beginDraw(); 
    natzke.pushMatrix(); 
    natzke.translate(0, 0, 0);
    ribbonManager.update(640-v1.x, v1.y);
    natzke.popMatrix();
  natzke.endDraw();
}


void eraseNatzke() {
  natzke.beginDraw();
    natzke.clear(0, 0, 0, 0);
  natzke.endDraw();
}


void mousePressed() {
 if(mouseButton == LEFT) {
   paint = 1;
   ribbonManager = new RibbonManager(ribbonAmount, ribbonParticleAmount, randomness, ribbonCounter);
 }
 if(mouseButton == RIGHT) {
   eraseNatzke();
 }
}


void mouseReleased() {
  paint = 0;  
}


void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
  else if(key != CODED) {
    if(key == 's') {
      saveFrame("save.tif");
    }   
  }
}


void stop() {
  tracker.quit();
  super.stop();
}
