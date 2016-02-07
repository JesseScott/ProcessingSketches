
String lines[];

void setup() {
  size(800, 800);
  fill(255);
  background(0);
  //lines = loadStrings
  //("http://toolserver.org/~daniel/WikiSense/Contributors.php?wikifam=.wikipedia.org&wikilang=en&order=-edit_count&page=Great_Fire_of_Rome&grouped=on&ofs=0&max=1000");  
}

void draw() {
  background(0);
  textSize(36);
  //text(lines[frameCount % lines.length], 100, 400); 
  text(frameCount, 100, 600);
  stroke(255, 0, 0);
  line(0, 0, width, height);
}

