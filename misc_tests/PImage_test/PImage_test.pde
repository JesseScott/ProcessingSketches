

PGraphics pg;
secondApplet s;
PFrame f;
  
void setup() {
  size(640, 480, JAVA2D);
  background(0);
  
  frame.setLocation(0,0);
  f = new PFrame();
  
  pg  = createGraphics(640,  480, JAVA2D);  
 
} 
  
  
void draw() {
  
  pg.beginDraw();
    pg.fill(255,0,0);
    pg.rect(50,50,50,50);
    pg.line(mouseX, mouseY, pmouseX, pmouseY);
  pg.endDraw();
  
  image(pg, 0, 0);
  
} 


public class PFrame extends Frame {
  public PFrame() {
    setBounds(0, 0, 640, 480);
    s = new secondApplet();
    add(s);
    removeNotify(); 
    setUndecorated(false);   
    setResizable(false);
    addNotify(); 
    setLocation(0, 0);
    s.init();
    //show();
    setVisible(true);
  }
}

public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(false);   
  frame.setResizable(false);
  frame.addNotify(); 
  super.init();
}

public class secondApplet extends PApplet {
  
  public void setup() {
    size(640, 480);
    background(0);
  }
 
  public void draw() {
    if(pg != null) {
      image(pg, 0, 0);
    }
  }
}

//-----------------------------------------------------------------------------------------


