
//___________________
//IMPORT
import ddf.minim.*;
import ddf.minim.analysis.*;

//DECLARATIONS
Minim minim;
AudioInput in;
FFT fft;

int spectrum = 1024;
color prev, next;
float highFreq, lastFreq, currFreq;
float c = 0.0;

void setup(){
  size(512, 200); 

  // COLOUR
  colorMode(HSB);

  // Audio Setup
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, spectrum);
  fft = new FFT(spectrum, spectrum);
  //fft.window(FFT.HAMMING);
  
}

 

void draw() {
  // Clear Background
  background(0);
  
  // FFT Analysis
  fft.forward(in.mix);
  
  // DRAW
  stroke(255);

  // LOOP
  for(int i = 0; i < fft.specSize(); i++) {
//    if(fft.getBand(i) > currFreq) {
//      currFreq = fft.getBand(i);
//    }
    line(i, height, i, height - fft.getBand(i)*8);
  }
  //println("Highest Freq is Band " + currFreq); 

  
  // CHECK
  if(millis() / 1000 == 0) {
    println("CHECK");
      
    for(int i = 0; i < fft.specSize(); i++) {
      if(fft.getBand(i) > currFreq) {
        currFreq = fft.getBand(i);
        
      }
      println(i);
      println(millis());
    }   
    println("Highest Freq is Band " + currFreq); 
    
    lastFreq = highFreq;
    highFreq = currFreq;
    prev = color(lastFreq, 99, 99);
    next = color(highFreq, 99, 99);
    println(lastFreq + " \t" + highFreq + "\t" + currFreq);
    currFreq = 0;
  }
  
  // ANIMATION
  c = millis();
  float m = (c % 10000) / 10000;
  //println("M " + m);

  // FILL
  color lerped = lerpColor(prev, next, m);
  fill(lerped);
  noStroke();
  rect(0, 0, width, height/2);

  stroke(255);
  line(0, highFreq, width, highFreq);
  
}

void stop(){
  in.close();
  minim.stop();
  super.stop();
}



