
// Libraries
import ddf.minim.*;

// Variables
int fadeDown = 0; 
int fadeUp = 0;
int nfu;

// Declare Images
PImage bvg;
PImage white;
PImage Alexander;
PImage Frankfurter;
PImage Hermannplatz;
PImage Kotbusser;
PImage Osloer;
PImage Ostbahnhof;
PImage Schonefeld;
PImage Leopold;
PImage Gesundbrunnen;
PImage Zoo;
PImage Rosenthaler;
PImage Moritzplatz;
PImage RathausNK;
PImage Yorckstrasse;
PImage Warschauer;
PImage Bernauer;
PImage Potsdamer;
PImage Mehringdam;
PImage Tegel;

// Declare Minim
Minim minim;
AudioPlayer field;

/* SETUP */
void setup() {

  // Canvas
  size(1336,943, JAVA2D);
  background(255);
  smooth();
  frameRate(10);
  
  // Minim
  minim = new Minim(this);
  field = minim.loadFile("field.wav", 2048); // 16-bit Signed WAV
  // field.play();
  // field.loop();

  // Load Images
  bvg = loadImage("bvg.jpg");
  white = loadImage("white.jpg");

  Alexander = loadImage("Alexander.jpg");
  Zoo = loadImage("Zoologischer.jpg");
  Frankfurter = loadImage("Frankfurter.jpg");
  Hermannplatz = loadImage("Hermannplatz.jpg");
  Kotbusser = loadImage("Kotbusser.jpg");
  Osloer = loadImage("Osloer.jpg");
  Ostbahnhof = loadImage("Ostbahnhof.jpg");
  Schonefeld = loadImage("Schonefeld.jpg");
  Leopold = loadImage("Leopoldplatz.jpg");
  Gesundbrunnen = loadImage("Gesundbrunnen.jpg");
  Rosenthaler = loadImage("Rosenthaler.jpg");
  Moritzplatz = loadImage("Moritzplatz.jpg");
  RathausNK = loadImage("RathausNK.jpg");
  Yorckstrasse = loadImage("Yorckstrasse.jpg");
  Warschauer = loadImage("Warschauer.jpg");
  Bernauer = loadImage("Bernauer.jpg");
  Potsdamer = loadImage("Potsdamer.jpg");
  Mehringdam = loadImage("Mehringdam.jpg");
  Tegel = loadImage("Tegel.jpg");
  
}  // end setup


/* DRAW*/
void draw() {

  int x = mouseX;
  int y = mouseY;
  //println(x + " : " + y);


  // COUNTERS
  float sec = millis() / 1000.0 * 15; // this takes about 15 seconds
  int Second = millis() / 1000;
  int roundSec = round(sec);
  //println(roundSec);
  if(millis() > 0) {
    fadeDown = 255 -roundSec; // Count from 255 to 0
    fadeUp = 0 + roundSec; // Count from 0 to 255
    
    tint(255, fadeDown); // Tint BVG Image Alpha to 0
    image(bvg, 0, 0); 
    tint(255, fadeUp); // Tint White Image Alpha to 255
    image(white, 0, 0);

    if(fadeDown < 0) {
      fadeDown = 0;
    }
    if(fadeUp > 255) {
      fadeDown = 255;
    }
  }

  if(Second > 15) {
    // Fade In
    nfu = fadeUp - 300;
    if(nfu > 254) {
      nfu = 255;
    }
    
    // Draw Lines + Curves 
     strokeWeight(3);
     smooth();  
     noFill();
     
    // Red Line
     stroke(255, 0, 0, nfu);
     bezier(807, 588, 735, 667, 790, 602, 936, 869); // Schonefeld to RHNK
     bezier(807, 588, 872, 518, 840, 454, 798, 471); // RHNK to Ostbahnhof

    // Green Line
     stroke(60, 240, 10, nfu);
     bezier(791, 478, 740, 538, 700, 581, 593, 571); // Ostnahnhof to Yorckstrasse
     bezier(588, 566, 584, 528, 532, 517, 564, 484); // Yorckstrasse to Potsdamer
     bezier(573, 475, 880, 261, 852, 435, 821, 495); // Potsdamer to Warschauer
     
    // Blue Line
     stroke(10, 60, 240, nfu);
     bezier(573, 475, 658, 445, 738, 511, 763, 502); // Potsdamer to Moritzplatz
     bezier(763, 502, 824, 413, 712, 335, 690, 361); // Moritzplatz to Rosenthaler
     bezier(690, 361, 600, 389, 589, 278, 634, 305); // Rosenthaler to Gesundbrunnen
     
    // Yellow Line
     stroke(255, 255, 0, nfu);
     bezier(814, 502, 675, 530, 696, 452, 738, 425); // Warschauer to Alexander
     bezier(750, 413, 809, 266, 522, 249, 511, 281); // Alexander to Leopold
     bezier(511, 281, 401, 339, 413, 471, 437, 480); // Leopold to Zologischer
     bezier(450, 493, 537, 526, 651, 389, 670, 339); // Zoologischer to Bernauer
     
    // Purple Line
     stroke(148, 0, 255, nfu);
     bezier(670, 339, 724, 266, 975, 472, 916, 471); // Bernauer to Frankfurter
     bezier(903, 471, 854, 467, 791, 557, 763, 568); // Frankfurter to Hermannplatz
     
    // Orange Line
     stroke(255, 50, 0, nfu);
     bezier(916, 471, 999, 522, 790, 525, 763, 524); // Frankfurter to Kotbusser
     bezier(763, 524, 468, 549, 445, 177, 561, 231); // Kotbusser to Osloer
  }

  // Draw Stations

  // Ellipses
  stroke(0);
  strokeWeight(1);
  fill(0);
  smooth();

  ellipse(561, 231, 5, 5); // Osloer
  ellipse(763, 524, 5, 5); // Kotbusser Tor
  ellipse(763, 568, 5, 5); // Hermannplatz
  ellipse(763, 502, 5, 5); // Moritzplatz
  ellipse(807, 588, 5, 5); // Rathaus Neukolln
  ellipse(690, 361, 5, 5); // Rosenthalerplatz
  ellipse(936, 869, 5, 5); // Schonefeld
  ellipse(511, 281, 5, 5); // Leopoldplatz
  ellipse(588, 571, 5, 5); // Yorkstrasse
  ellipse(593, 571, 5, 5); // Yorkstrasse
  ellipse(588, 566, 5, 5); // Yorkstrasse
  ellipse(670, 339, 5, 5); // Bernauer
  ellipse(654, 563, 5, 5); // Mehringdam
  ellipse(384, 153, 5, 5); // Alt=Tegel
  ellipse(388, 149, 5, 5); // Tegel

  // Lines
  stroke(0);
  fill(255);
  strokeWeight(5);
  smooth();
  strokeJoin(ROUND);

  line(634, 305, 646, 317); // Gesundbrunnen
  line(903, 471, 916, 471); // Frankfurter Allee
  line(437, 480, 450, 493); // Zoologischer Garten
  line(738, 425, 750, 413); // Alexanderplatz
  line(791, 478, 798, 471); // Ostbahnhof
  line(814, 502, 821, 495); // Warschauer
  line(573, 475, 564, 484); // Potsdamer
  
 // Fade In 
  if(Second > 25) {
    
  // MouseOvers
  
  if ( mouseX > 737 && mouseX < 751 && mouseY > 412 && mouseY < 426 ) { // Alexander
    if ( mousePressed == true ) {
      noCursor();
      roundSec = 0;

      println(roundSec);
      tint(255, roundSec);
      image(Alexander, 744-150, 419-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 667 && mouseX < 673 && mouseY > 336 && mouseY < 342 ) { // Bernauer
     if ( mousePressed == true ) {
       noCursor();
       image(Bernauer, 670-150, 339-200, 300, 440);
       field.pause();
     } 
     else { 
       field.play(); 
       cursor();
     }
  } 
  if ( mouseX > 900 && mouseX < 919 && mouseY > 468 && mouseY < 474 ) { // Frankfurter
    if ( mousePressed == true ) {
      noCursor();
      image(Frankfurter, 910-150, 471-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 632 && mouseX < 648 && mouseY > 303 && mouseY < 319 ) { // Gesundbrunnen
     if ( mousePressed == true ) {
      noCursor();
      image(Gesundbrunnen, 640-150, 311-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 760 && mouseX < 766 && mouseY > 565 && mouseY < 571 ) { // Hermannplatz
    if ( mousePressed == true ) {
      noCursor();
      image(Hermannplatz, 763-150, 568-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 760 && mouseX < 766 && mouseY > 521 && mouseY < 527 ) { // Kotbusser
    if ( mousePressed == true ) {
      noCursor();
      image(Kotbusser, 763-150, 524-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 508 && mouseX < 514 && mouseY > 278 && mouseY < 284 ) { // Leopold
    if ( mousePressed == true ) {
      noCursor();
      image(Leopold, 511-150, 281-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 760 && mouseX < 766 && mouseY > 500 && mouseY < 504 ) { // Moritzplatz
    if ( mousePressed == true ) {
      noCursor();
      image(Moritzplatz, 763-150, 502-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 651 && mouseX < 657 && mouseY > 560 && mouseY < 566 ) { // Merhringdam
    if ( mousePressed == true ) {
      noCursor();
      image(Mehringdam, 651-150, 560-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 558 && mouseX < 564 && mouseY > 228 && mouseY < 234 ) { // Osloer
    if ( mousePressed == true ) {
      noCursor();
      image(Osloer, 561-150, 231-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 790 && mouseX < 799 && mouseY > 470 && mouseY < 479 ) { // Ostbahnhof
    if ( mousePressed == true ) {
      noCursor();
      image(Ostbahnhof, 794-150, 475-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 562 && mouseX < 575 && mouseY > 473 && mouseY < 486 ) { // Potsdamer 
    if ( mousePressed == true ) {
      noCursor();
      image(Potsdamer, 568-150, 479-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 804 && mouseX < 810 && mouseY > 585 && mouseY < 591 ) { // Rathaus NK 
    if ( mousePressed == true ) {
      noCursor();
      image(RathausNK, 807-150, 588-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 687 && mouseX < 693 && mouseY > 358 && mouseY < 364 ) { // Rosenthaler 
    if ( mousePressed == true ) {
      noCursor();
      image(Rosenthaler, 690-150, 361-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 933 && mouseX < 939 && mouseY > 866 && mouseY < 872 ) { // Schonefeld
    if ( mousePressed == true ) {
      noCursor();
      image(Schonefeld, 936-150, 869-400, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }   
  if ( mouseX > 385 && mouseX < 391 && mouseY > 146 && mouseY < 152 ) { // Tegel
    if ( mousePressed == true ) {
      noCursor();
      image(Tegel, 388-150, 149-100, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }     
  if ( mouseX > 812 && mouseX < 823 && mouseY > 493 && mouseY < 504 ) { // Warschauer
    if ( mousePressed == true ) {
      noCursor();
      image(Warschauer, 794-150, 475-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  } 
  if ( mouseX > 585 && mouseX < 595 && mouseY > 564 && mouseY < 574 ) { // Yorckstrasse
    if ( mousePressed == true ) {
      noCursor();
      image(Yorckstrasse, 590-150, 569-200, 300, 440);
      field.pause();
    } 
    else { 
      field.play(); 
      cursor();
    }
  }
  if ( mouseX > 436 && mouseX < 451 && mouseY > 479 && mouseY < 494 ) { // Zoologischer
    if ( mousePressed == true ) {
      noCursor();
      image(Zoo, 444-150, 487-200, 300, 440);
      field.pause();
    }
    else { 
      field.play(); 
      cursor();
    }
  } 
 } // end Fade
 
 // Save Frame
 //saveFrame("save/####.tif"); 
  
}  // end draw


 
void stop()
{
  field.close();
  minim.stop();
  super.stop();
}
