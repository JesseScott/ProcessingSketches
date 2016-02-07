/*

GoBang


*/

// IMPORTS


// DECLARATIONS
WhiteStone ws;
BlackStone bs;

// VARIABLES
int countWhite = 0;
int countBlack = 0;
int maxStone = 180; 
boolean turn = true; // start with white
boolean whiteMoved = false;
boolean blackMoved = false;

//------------//

void setup() {
  
  // Screen
  size(1000,1000);
  background(255);
  stroke(0);
  strokeWeight(2);
  smooth();
  ellipseMode(CENTER);
  
  // Draw Board
  // Horizontal Lines
  for (int i = 50; i < 960; i += 50) {
    line(50,i,950,i);
  }  
  // Vertical Lines
  for (int i = 50; i < 960; i += 50) {
    line(i,50,i,950);
  }
  // Handicap Points
  fill(5);
  ellipse(200,200,5,5);
  ellipse(200,500,5,5);
  ellipse(200,800,5,5);
  ellipse(500,200,5,5);
  ellipse(500,500,5,5);
  ellipse(500,800,5,5);
  ellipse(800,200,5,5);
  ellipse(800,500,5,5);
  ellipse(800,800,5,5);
  
  
}  // end



//------------//

void draw() {
  smooth();
  if(frameCount % 10 == 0) {
    println(mouseX + " " + mouseY); 
  }

  if(whiteMoved == true) {
    ws.display();    
  }
  if(blackMoved == true) {
    bs.display();    
  }
 
} // end


//------------//

void mouseReleased() {

}

void mousePressed() {
  if((mouseX % 50 == 0) && (mouseY % 50 == 0)) {
    if(turn == true) {
       ws = new WhiteStone(mouseX, mouseY);
       println("Adding New White Stone");
       whiteMoved = true;
    }
    else {
      bs = new BlackStone(mouseX, mouseY);
      println("Adding New Black Stone");
      blackMoved = true;
    }
    turn =! turn;
    println(turn);
  }
}


//------------//






