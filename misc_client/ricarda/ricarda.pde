
// IMPORTS
import ddf.minim.*;
import ddf.minim.analysis.*;

// DECLARATIONS
Minim minim;
AudioInput in;
BeatDetect beat;
BeatListener bl;
FFT fft;

// VARIABLES
color col1 = color(0,0,0); 
color col2 = color(0,0,0);
int count = 0;
int diff;
boolean updown;

// SETUP
void setup() {
  size(512, 200);
  smooth();
  frameRate(15);
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(10000);  
  bl = new BeatListener(beat, in);  
  
}


// DRAW
void draw() {
  background(0);
  
  
  
  if(beat.isSnare() == true) {
    col2 = col1;
    col1 = int(random(0,255));
    
  }
  if(frameCount % 15 == 0) {
    if(col2 < col1) {
      println("less"); 
      updown = false;
      count = col1;
      diff = col1 - col2;
    }
    else {
      println("more"); 
      updown = true;
      count = col2;
      diff = col2 - col1;
    }
    if(updown == false) {
      count--; 
      if(count <= col2) count = col2;
    }
    else {
      count++;
      if(count >= col1) count = col1;
    }
  }
    col1 = col1 + count;
    println(count);
    background(count);
  
  
  
  fft.forward(in.mix);
  for(int i = 0; i < fft.specSize(); i++) {
    //line(i, height, i, height - fft.getBand(i)*4);
  }
  
  for(int i = 0; i < in.bufferSize() - 1; i++) {
   /*
    float r = map(in.left.get(i), 0.0, 1.0, 0.0, 255.0);
   float g = map(in.right.get(i), 0.0, 1.1, 0.0, 128.0);
   float b = map(in.mix.get(i), 0.0, 1.1, 0.0, 512.0); 
   stroke(r, g, b);
   strokeWeight(i);
   line(i, 0, i, height);
  */
    /*
    float hiVal = 0.0;
    float newVal = map(in.mix.get(i), 0.0, 0.1, 0.0, 1.0);
    if(newVal >= hiVal) {
      float _i = float(i); 
      _i = hiVal; 
    }
    println(newVal);
    int w = 1;
    w++;
    fill(i, i+w, w);
    rectMode(CENTER);
    rect(hiVal, height/2, w, w/2);
    */
    //line(i, 150 + in.mix.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
  
  //rect(0, 0, width, height);
  
}


// STOP
void stop() {
  in.close();
  minim.stop();
  super.stop();
}

// BEAT LISTENER
class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioInput in;
  
  BeatListener(BeatDetect beat, AudioInput in) {
    this.in = in;
    this.in.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps) {
    beat.detect(in.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR) {
    beat.detect(in.mix);
  }
}
