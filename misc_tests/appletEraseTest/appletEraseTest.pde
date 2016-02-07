
PGraphics pg1;
PGraphics pg2;

secondApplet s;
PFrame f;

//-----------------------------------------------------------------------------------------

void setup() {
  size(400, 400, JAVA2D);
  background(0);
  stroke(255);
  
  frame.setLocation(0,0);
  f = new PFrame();
  
  pg1 = createGraphics(400, 400, JAVA2D);  
  pg2 = createGraphics(400, 400, JAVA2D); 
}

void draw() {
  pg1.beginDraw();
    pg1.stroke(255);
    pg1.line(mouseX, mouseY, pmouseX, pmouseY);
  pg1.endDraw();
  image(pg1, 0, 0);
}

//-----------------------------------------------------------------------------------------

public class PFrame extends Frame {
    public PFrame() {
        setBounds(0, 0, 400, 400);
        s = new secondApplet();
        add(s);
        removeNotify(); 
        setUndecorated(false); 
        setTitle("Second Applet");
        setResizable(false);
        addNotify(); 
        setLocation(0, 0);
        s.init();      
        show();
        setVisible(true);
    }
}



public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(false);   
  frame.setResizable(false);
  frame.addNotify(); 
  frame.setTitle("First Applet");
  super.init();
}

public class secondApplet extends PApplet {
  
    public void setup() {
      size(400, 400);
      background(0);


    }
 
    synchronized public void draw() {
      if(pg2 != null) {
        pg2.beginDraw();
          pg2.copy(pg1, 0, 0, pg1.width, pg1.height, 0, 0, pg2.width, pg2.height);
        pg2.endDraw();
        image(pg2, 0, 0);
      }
    }
}

//-----------------------------------------------------------------------------------------

void mousePressed() {
  println("?!?");
  
  pg1.background(0);

  color c = color(0,0);
  pg1.beginDraw();
    pg1.loadPixels();
    for (int x = 0; x < pg1.width; x++) {
      for (int y = 0; y < pg1.height; y++ ) {
        int loc = x + y * pg1.width;
        pg1.pixels[loc] = c;
      }
    }
    pg1.updatePixels();
  pg1.endDraw();
}
