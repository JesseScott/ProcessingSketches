  // Android Example for Weave Magazine 02.11
  //
  // android3D.pde
  // Shows the basic use of the 3D Renderer
  //
  // Written by Cedric Kiefer / Jesse Scott
  // www.onformative.com
  //
  // With Code from Andrés Colubri http://codeanticode.wordpress.com
  // 
  // Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
  // Android SDK Tools Revision 6, API Level 7
  
  //-----------------------------------------------------------------------------------------
  
  void setup() {
    size(displayWidth, displayHeight, P3D);
    strokeWeight(3);
    stroke(255);
    noFill();
  }
  
//-----------------------------------------------------------------------------------------
  
  void draw() {
    println(frameRate);
    background(0); 
    translate(width/2, height/2, 0);
    pushMatrix();
    rotateY(frameCount*PI/185);
    box(150, 150, 150);
    popMatrix(); 
    pushMatrix();
    rotateX(-frameCount*PI/200);
    popMatrix();  
  }
  
  //-----------------------------------------------------------------------------------------
  // Override the parent (super) Activity class:
  
  void onResume() {
    super.onResume();
    println("RESUMED! (Sketch Entered...)");
  }
  
  void onPause() {
    println("PAUSED! (Sketch Exited...)");
    super.onPause();
  } 
