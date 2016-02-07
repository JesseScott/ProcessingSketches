
int authors = 1000;
int versions = 1001; 

String names[] = new String[authors];
String edits[] = new String[authors];
String changes[] = new String[versions];
int    diff[] = new int[versions];

int mode = 2;
PFont lrg, med, sml;
    
//------------

void setup() {
  size(1024, 768);
  smooth();
  lrg = loadFont("Serif-48.vlw");
  med = loadFont("Serif-36.vlw");
  sml = loadFont("Serif-24.vlw");
  frameRate(30);
  
  // LOAD
  
  String[] chars;
  chars = loadStrings("http://en.wikipedia.org/w/index.php?title=20_July_plot&offset=&limit=1000&action=history");
  String lines[];
  lines = loadStrings("http://toolserver.org/~daniel/WikiSense/Contributors.php?wikifam=.wikipedia.org&wikilang=en&order=-edit_count&page=20_July_plot&grouped=on&ofs=0&max=1000");
 
  // Edits
  String name;
  String edit;
  int userCount = 0;
  int counter = 0;
  int curr = 0;

  for(int i = 0; i < lines.length; i++) {
    // Only Get Lines that Contain The Username
    if( lines[i].contains("title=User:")  ) {
      int si = lines[i].indexOf("'>") +2; // Start Index of 1st Character In Name
      int fi = lines[i].indexOf("</") -1; // Final Index of last Character In Name
      int ei = lines[i -1].indexOf("(");  // Edit Index of Number Of Edits In Previous Line
      
      String letters[] = new String[(fi - si) +1]; // Array Of Number Of Characters In Name
      
      // Add All Characters Into A String
      while(si + counter <= fi) {
        curr = si + counter; // Calculate Current Position
        letters[counter] = str(lines[i].charAt(curr)); // Add Current Character To Array
        counter++; // Iterate
      }
      counter = 0; // Reset For Next User

      edit = str(lines[i-1].charAt(ei -2)); // Find The Number Of Edits A User has Committed
      name = join(letters, ""); // Concatenate All Characters Into A String
      
      names[userCount] = name;
      edits[userCount] = edit;
      userCount++;
      
      //println("NAME \t" + name + " \t \t EDITS \t" + edit);
    }
  }

  // Changes
  counter = 0;
  userCount = 0;
  String plusMinus;
  String rejoined;
  String z, p, n;
  boolean zero = false;
  boolean posneg = false;
  char pos = '+';
  char neg = '-';
  
  for(int i = 0; i < chars.length; i++) {
    if(chars[i].contains("after change")) {
      //println(chars[i]); 
      int si = chars[i].indexOf("change\">(") +9; // + or -
      String end = ")";
      int endIndex = 0;
      
      for(int j = 1; j < 8; j++) { // Max Number of Characters Changed - Find If Less
        if(str(chars[i].charAt(si + j)).equals(end)) {
          break;
        }
        else {
          endIndex = si + j;
          //println(str(chars[i].charAt(endIndex)));
        }
      }
      
      int len = (endIndex - si) +1;
      //println("ARRAY OF  " + len);
      // Test against 0 change (gives negative array size)
      if(len < 0) {
        len = 0; 
        zero = true;
      }
      else {
        zero = false;
      }
      String letters[] = new String[len];
      
      while(si + counter <= endIndex) {
        curr = si + counter; 
        letters[counter] = str(chars[i].charAt(curr)); 
        counter++; 
      }
      counter = 0; 

      plusMinus = join(letters, ""); 

      // Trim The Comma
      if(plusMinus.contains(",")) {
          //println("THIS ONE \t" + plusMinus); 
          String temp = plusMinus;
          //println("TEMP " + temp);
          String[] divide = split(temp, ',');
          //println("DIVIDE " + divide[0] + "  " + divide[1]);
          rejoined = join(divide, "");
          //println("REJOINED " + rejoined);
          plusMinus = rejoined;
      }
      
      // Figure Out +- or 0
      if(zero == true) {
        //println("ZER");
        z = "0";
        plusMinus = z;
        //println(plusMinus);
      }
      else if(zero == false) { 
        if(plusMinus.charAt(0) == pos) {
          //println("POS");
          p = plusMinus.substring(1);
          //println(p);
          plusMinus = p;
        }
        else if(plusMinus.charAt(0) == neg) {
          //println("NEG");
          n = plusMinus.substring(1);
          //println(n);
        }
      }
      
      userCount++;
      changes[userCount] = plusMinus;
      //println("CHANGES \t" + changes[userCount]);
      diff[userCount] = int(plusMinus);
      //println("DIFF \t" + diff[userCount]);
    }
  }

  //exit();
}

//-------------------------------------------------//

void draw() {
  background(255);  
  
  if(mode == 1) { // Edits In The Timeline
    pushStyle();
    pushMatrix();
      
    String edit = "507 Editors \nAug 8th,  2003 - July 15th, 2012";
    text(edit, 240, 360);
    

    popStyle();
    popMatrix();
  }
  else   if(mode == 2) { // Number Of Edits Per Editor
    pushStyle();
    pushMatrix();
    
      int diameter = 3*(height/4);

      int[] angs = {
        38, 32, 31, 27, 24, 22, 13, 11, 
        9, 9, 9, 9, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 
        6, 6, 6, 6, 22   
      };
      float lastAng = 0;
      //stroke(255, 128);
      
      for (int i = 0; i < angs.length; i++){
        //println(i);
        if(i == angs.length -1) {
          fill(0); 
          stroke(255, 128);
        }
        else {
          noStroke();
          fill(map(angs[i], 1, 38, 255, 0), map(angs[i], 1, 38, 0, 255), map(angs[i], 6, 38, 100, 255));
        }
        arc(width/3, height/2, diameter, diameter, lastAng, lastAng+radians(angs[i]));
        lastAng += radians(angs[i]);  
      }
      
      fill(0);
      String edit = "Number of Edits per Editor";
      textFont(lrg);
      text(edit, 100, 50);
      
      String editors = " 1727 Editors at Less \n Than 3 Edits apiece";
      textFont(sml);
      text(editors, 700, 325);
      stroke(0, 128);
      line(626, 335, 695, 335);
      
    popStyle();
    popMatrix();
  }
  else   if(mode == 3) { // Character Change Per Edit
    pushStyle();
    pushMatrix();
      fill(0);
      String title = "Character Change Per Edit";
      textFont(lrg);
      text(title, 100, 50);
      translate(10, height/2);
      noFill();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0, 128, 255);
      line(0, 0, width - 100, 0);
      strokeWeight(3);
      
      for(int i = 0; i < diff.length; i++) {
        //println(i + " " + diff[i]);
        if(i == 206 || i == 207) {
          diff[i] = 0;
        }
        if(diff[i] < 0) {
          float n = map(diff[i] , -48000, 0, -320, 0);
          stroke(i * 0.05, 128 + (i * 0.25), abs(n));
          line(i, 0, i, n);
        }
        else if(diff[i] > 0) {
          float p = map(diff[i] , 0, 48000, 0, 320);
          stroke(p, 64 + (i * 0.15), i * 0.25);
          line(i, 0, i, p); 
        }  
      }
      fill(0);
      textFont(med);
      String now = "2012";
      text(now, 0, 350);
      String then = "2002";
      text(then, width -100, 350);
      
    popStyle();
    popMatrix();
  }
  else   if(mode == 4) { // Largest Character Change
    pushStyle();
    pushMatrix();
      fill(0);
      String edit = "\"You r such a butt face!! \n  :P \"";
      textFont(lrg);
      text(edit, 120, 240);
      String editor = " - '169.244.87.146' \n  April 13th, 2010";
      textFont(med);
      text(editor, 120, 480);
    
    popStyle();
    popMatrix();
  }
  
   
  
}

//------------

void mousePressed() {
  mode++; 
  if(mode == 5) mode = 2;
  
  
}

void keyPressed() {
  if(key == 's') {
    save("J20_" + mode + ".png");
  } 
}

