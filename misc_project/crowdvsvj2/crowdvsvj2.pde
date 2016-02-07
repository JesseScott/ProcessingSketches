
// IMPORT
import processing.opengl.*;
import king.kinect.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;
import peasy.*;


// DECLARATIONS
PImage depth;
PeasyCam cam;

// MIMIN SETUP
Minim minim;
AudioInput in;
BeatDetect beat;
// BeatListener bl;

float tolerance = 1;
float targetDepth = 0.5;
int skip = 8;
float r, g, b;
float pulse;

// SETUP
void setup() {
  size(1600,1200,P2D);
  background(0);
  //cam = new PeasyCam(this, width);
  NativeKinect.init();
  NativeKinect.start();
  depth = createImage(640,480,RGB);

  // Minim
  minim = new Minim(this);
  minim.debugOn(); 
  in = minim.getLineIn(Minim.STEREO, 1024);
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(100);
  // bl = new BeatListener(beat, in); // Frequency Listener
} //----

static final int gray(color value) { 
  return max((value >> 16) & 0xff, (value >> 8 ) & 0xff, value & 0xff);
} 


// DRAW
void draw() {
  println("FR " + frameRate);
  // background(0);
  
  // Minim
  beat.detect(in.mix);

  if ( beat.isKick() == true) {
    r = random(10);
    //println("KICK ");
  }
  if ( beat.isSnare() == true) {
    g = random(20);
    //println("SNARE ");
  }
  if ( beat.isHat() == true) {
    b = random(30);
    //println("HAT ");
  }

  depth.pixels = NativeKinect.getDepthMap();
  depth.updatePixels();
  //image(depth,640,0,640,480); // Depth Image

  if(targetDepth > 0) {
    float pulse = map(in.mix.level(), 0, 0.5, 0, 100);
    // println("PULSE " + pulse);
    float d = 0;
    for(int x = 0; x < 320; x+=skip) {
      for(int y = 0; y < 240; y+=skip) {
        int loc = x + y * depth.width;
        d = gray(depth.pixels[loc]);
        if((targetDepth < d + tolerance) && (targetDepth > d - tolerance) ) {
          stroke(r*pulse, g*pulse, b*pulse);
        } 
        else {
          stroke(depth.pixels[loc] + pulse/2, depth.pixels[loc] - pulse*4.5, depth.pixels[loc] - pulse*2, pulse);

        }
        // ROW 1
        line(x, y, x, y); // 1, 1
        line(320 + x, y, 320 + x, y); // 1, 2
        line(640 + x, y, 640 + x, y); // 1, 3
        line(960 + x, y, 960 + x, y); // 1, 4
        line(1280 + x, y, 1280 + x, y); // 1, 5
        // ROW 2
        line(x, 240 + y, x, 240 + y); // 2, 1
        line(320 + x, 240 + y, 320 + x, 240 + y); // 2, 2
        line(640 + x, 240 + y, 640 + x, 240 + y); // 2, 3
        line(960 + x, 240 + y, 960 + x, 240 + y); // 2, 4
        line(1280 + x, 240 + y, 1280 + x, 240 + y); // 2, 5
        // ROW 3
        line(x, 480 + y, x, 480 + y); // 3, 1
        line(320 + x, 480 + y, 320 + x, 480 + y); // 3, 2
        line(640 + x, 480 + y, 640 + x, 480 + y); // 3, 3
        line(960 + x, 480 + y, 960 + x, 480 + y); // 3, 4
        line(1280 + x, 480 + y, 1280 + x, 480 + y); // 3, 5
        // ROW 4
        line(x, 720 + y, x, 720 + y); // 4, 1
        line(320 + x, 720 + y, 320 + x, 720 + y); // 4, 2
        line(640 + x, 720 + y, 640 + x, 720 + y); // 4, 3
        line(960 + x, 720 + y, 960 + x, 720 + y); // 4, 4
        line(1280 + x, 720 + y, 1280 + x, 720 + y); // 4, 5
        // ROW 5
        line(x, 960 + y, x, 960 + y); // 5, 1
        line(320 + x, 960 + y, 320 + x, 960 + y); // 5, 2
        line(640 + x, 960 + y, 640 + x, 960 + y); // 5, 3
        line(960 + x, 960 + y, 960 + x, 960 + y); // 5, 4
        line(1280 + x, 960 + y, 1280 + x, 960 + y); // 5, 5
        

      }
    } // for
  } // target depth
} // ------


void stop()
{
  // always close Minim audio classes when you are finished with them
  in.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
} //----

