
// IMPORTS
import processing.video.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

// DECLARATIONS
Minim minim;
AudioInput in;
Movie mov;

// VARIABLES
float where;

//----------------------------

void setup() {
  // Screen
  size(720, 480);
  
  // Minim
  minim = new Minim(this);
  //minim.debugOn(); 
  in = minim.getLineIn(Minim.STEREO, 512); 
  
  // Movie
  mov = new Movie(this, "storm.mov");
  println(mov.duration());
  
}

//----------------------------

void movieMov(Movie mov) {
  mov.read();  
}

//----------------------------

void draw() {
  image(mov, 0, 0);

  where = map(in.mix.level(), 0.0, 1.0, 0.0, mov.duration());
  mov.jump(where);
  //println(where);
  
}

//----------------------------

void stop() {
  in.close();
  minim.stop();
  super.stop();
}
