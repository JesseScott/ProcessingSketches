//size a multiple of 24 (because it's a clock)
//in this instance 20*24

int h=hour(), m=minute();

import ddf.minim.*;

Minim minim;
AudioPlayer player;

void setup(){
size ( 480, 200);
  minim = new Minim(this);
  // load a file, give the AudioPlayer buffers that are 2048 samples long
 player = minim.loadFile("test.mp3", 2048);

}

void draw(){
  int t = h*20+m/3;
  background(255);
  fill(0, 102, 153);
  secondLine();
  time();
  timeLine();
  if(t == mouseX){
     // play the file
  player.play();}
  if(t < mouseX){
  player.pause();
}
}

//secondline just for show

void secondLine(){
  int s=second();
 line (s*8.3, 0, s*8.3, 200);
}

//number to multiply hour, taken from the dimension multiplier, number to divide minute derived from 60/20).

void time(){
  line (h*20+m/3, 0, h*20+m/3, 200);
}


void timeLine(){
  for (int i = 0; i < width; i+=20) {  
  line (i, 200, i, 180);
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  player.close();
  // always stop Minim before exiting
  minim.stop();
  
  super.stop();
}
    
