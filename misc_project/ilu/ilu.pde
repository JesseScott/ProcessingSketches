

// -----------------------------
// IMPORTS
// -----------------------------

import android.content.Context;
import android.app.Activity;
import android.os.Bundle;
import android.view.WindowManager;
import android.view.Window;
import android.os.Environment;


// -----------------------------
// DECLARATIONS
// -----------------------------



// -----------------------------
// VARIABLES
// -----------------------------

String[] fontList;
PFont font;

PGraphics parts, roses, heartLayer;

ParticleSystem ps1, ps2;
Heart[] hearts = new Heart[10];
PImage heart;
PImage rose;
PImage sprite;


// -----------------------------
// SETUP
// -----------------------------

void setup() {
  // Draw
  size(displayWidth, displayHeight, P2D);
  orientation(LANDSCAPE);
  
  // Rose
  rose = loadImage("rose.png");
  
  // Heart
  heart = loadImage("heart.png");
  for(int i = 0; i < 10; i++) {
    hearts[i] = new Heart(width/10 * i, random(-200, -100), random(4)); 
  }
  
  // Particles
  sprite = loadImage("sprite.png");
  ps1 = new ParticleSystem(250);  
  ps2 = new ParticleSystem(250);  
  hint(DISABLE_DEPTH_MASK);
  parts = createGraphics(displayWidth, displayHeight, P2D);
  parts.beginDraw();
    parts.image(rose, 0, 0, width, height);
  parts.endDraw();
  
  // Font
  fontList = PFont.list();
  font = createFont(fontList[4], 120, true);
  textFont(font);
  
  
  println("----");
  println("----");
  
}

// -----------------------------
// DRAW
// -----------------------------

void draw() {
  
  // Rose
  image(rose, 0, 0, width, height);

  // Fireworks
  ps1.update();
  ps1.display();
  ps1.setEmitter(width * 0.35, height/2); 
  ps2.update();
  ps2.display();
  ps2.setEmitter(width * 0.6, height/2);  
  image(parts, 0, 0);
  
  // Hearts
  for(int i = 0; i < 10; i++) {
    hearts[i].update();
    hearts[i].display();
  }
  
  // Text
  pushStyle();
    if(frameCount % 5 == 0) {
      fill(0);
    }
    else {
      fill(255); 
    }
    textSize(120);
    text(" i <3 u ", width * 0.375, height/2);
  popStyle();

println(frameRate);
    
}

// -----------------------------
// LIFECYCLE
// -----------------------------

@Override
void onResume() {
  super.onResume();

}

@Override
void onPause() {
  super.onPause();
  
}
