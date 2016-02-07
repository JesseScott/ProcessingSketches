
//-----------------------------------------------------------------

int ky = 0;
int sy = 0;
int hy = 0;
float k, s, h;
int kickCount = 0;
int snareCount = 0;
int hatCount = 0;

//-------------

void Mode_4() {
  // AUDIO REACTION
  pushStyle();    
  pushMatrix();
  
  // Screen
  background(0);
  translate(0, height/6);
  
  // Style
  rectMode(CENTER);
  colorMode(RGB);
  
  // Analyze Audio
  if(beat.isKick()) {
    //println("KICK");
    kickCount++;
    if(kickCount % 2 == 0) {
      k = random(255);
      ky = 0;
    }
  }
  if(beat.isSnare()) {
    //println("SNARE");
    snareCount++;
    if(snareCount % 2 == 0) {
      s = random(255);
      sy = 0;
    }
  }
  if(beat.isHat()) {
    //println("HAT");
    hatCount++;
    if(hatCount % 2 == 0) {
      h = random(255);
      hy = 0;
    }
  }  
  
  // Draw
  strokeWeight(ky*2);
  stroke(255, k*2);
  line(0, k + ky, width, k + ky);
  stroke(255, k);
  line(0, ky, width, ky);
  noFill();
  stroke(255, k/2);
  rect(width/2, k + ky*2, width +10, ky*2);

  strokeWeight(sy*2);
  stroke(255, s*2);
  line(0, s + sy, width, s + sy);
  stroke(255, s);
  line(0, sy, width, sy);
  noFill();
  stroke(255, s/2);
  rect(width/2, s + sy*2, width + 10, sy*2);

  strokeWeight(hy*2);
  stroke(255, h*2);
  line(0, h + hy, width, h + hy);
  stroke(255, h);
  line(0, hy, width, hy);
  noFill();
  stroke(255, h/2);  
  rect(width/2, h + hy*2, width + 10, hy*2);
  
  ky += 2;
  sy += 2;
  hy += 2;
  
  popMatrix();
  popStyle();
}



//-----------------------------------------------------------------

