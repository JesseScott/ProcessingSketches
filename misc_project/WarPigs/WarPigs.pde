
// IMPORTS

// DECLARATIONS

// VARIABLES
String File[];
String Parsed[];
String Name;
String StartDate;
String EndDate;
String Casualties;
String Epoch;

PFont Large, Small;
int Counter = 1;
int FileLength;

void setup() {
  size(800, 200);
  background(0);
  stroke(255);
  smooth();
  Large = createFont("Serif-48.vlw", 32, true);
  Small = createFont("Serif-48.vlw", 24, true);
  textAlign(CENTER);
  
  // ReadFile
  // from http://www.freebase.com/view/military/views/military_conflict
  String File[] = loadStrings("militaryConflict.csv"); 
  //FileLength = File.length;
  //println("Holy Shit... this file is " + FileLength + " lines long !!!");
 
}

//---------------

void draw() {
  background(0);
  
  // ReadFile
  String File[] = loadStrings("militaryConflict.csv"); 
  println(File.length);
  // Parse 
  String CurrLine = File[Counter];
  Parsed = split(CurrLine, ',');
  
  String Name        = Parsed[0];
  String StartDate   = Parsed[1];
  String EndDate     = Parsed[2];
  String Casualties  = Parsed[3];
  String Epoch       = Parsed[4];
  
   // BC or AD 

  // Get Int

  
  // Present
  textAlign(CENTER);
  
  textFont(Large);
  text(Name, width/2, (height/4)*1);
  
  textFont(Small);
  text("from " + StartDate + " to " + EndDate, width/2, (height/4)*2);
  
  if(Casualties.length() > 0) {
    text("an estimated " + Casualties + " dead...", width/2, (height/4)*3);
  }
  
}

//---------------

void keyPressed() {
 
  if(key == CODED) {
    if(keyCode == UP) {
      Counter = Counter - 1;
      if(Counter <= 0) {
        Counter = 0;
      }
    }
    else if(keyCode == DOWN) {
      Counter = Counter + 1;
      if(Counter > FileLength) {
        Counter = FileLength;
      }
    }  
    
  }

}

