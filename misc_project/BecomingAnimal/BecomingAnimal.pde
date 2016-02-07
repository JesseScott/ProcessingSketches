import processing.video.*;

Movie animal;
MovieMaker mm;
PFont font;

void setup() {
 size(960, 504, P2D);
 smooth();
 
 animal = new Movie(this, "Animal Drums 1.mov");
 animal.loop(); 
 
 mm = new MovieMaker(this, width, height, "becomingAnimal.mov", 30, MovieMaker.ANIMATION, MovieMaker.MEDIUM);
 
 font = createFont("SansSerif-48.vlw", 96, true);
 textFont(font); 
 textAlign(CENTER);
}

void movieEvent(Movie myMovie) {
  animal.read();
}

void draw() {
  background(0);
  scale(2.0);
  image(animal, 0, 0);
  fill(255, 155, 5);
  stroke(0);
  if(millis() % 20 < 10) {
    text("BECOMING", width/4, height/4);
  }
  
  mm.addFrame();
  //saveFrame("bA-####.tif");
  
}

void keyPressed() {
  if (key == ' ') {
    // Finish the movie if space bar is pressed
    mm.finish();
    // Quit running the sketch once the file is written
    exit();
  }
}
