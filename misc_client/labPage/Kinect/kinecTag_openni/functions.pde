
// -----------------------------------------------------------------
// PGraphics Buffer
void drawRibbon() {
  natzke.beginDraw(); 
    natzke.pushMatrix(); 
    natzke.translate(width * 0.25, height * 0.25, 0);
    natzke.scale(zoom);
    ribbonManager.update(screenPos.x, screenPos.y);
    natzke.popMatrix();
  natzke.endDraw();
}


void eraseNatzke() {
  natzke.beginDraw();
    natzke.clear(0, 0, 0, 0);
  natzke.endDraw();
}


// -----------------------------------------------------------------
// Mouse Events

void mousePressed() {
 if(mouseButton == LEFT) {
   paint = 1; 
   ribbonManager = new RibbonManager(ribbonAmount, ribbonParticleAmount, randomness, ribbonCounter);
 }
 else if(mouseButton == RIGHT) {
   eraseNatzke();
 }
}

void mouseReleased() {
  paint = 0;
}

void keyPressed() {
 if(key == 's') {
  saveFrame("save.tif");
 }   
}

