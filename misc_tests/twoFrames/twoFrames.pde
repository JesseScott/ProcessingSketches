
secondApplet s;
PFrame f;

//-----------------------------------------

void setup() {
  size(640, 480); 
  background(0);  
  f = new PFrame();  
}

void draw() {
  
  
}

//-----------------------------------------

public class PFrame extends Frame {
    public PFrame() {
        setBounds(100, 100, 640, 480);
        s = new secondApplet();
        add(s);
        
        removeNotify();
        setUndecorated(true);
        setResizable(false);
        setLocation(800, 0);
        
        s.init();
        show();
        //setVisible(true);
    }
}

//-----------------------------------------

public void init() {
  // This works upon the main applet
  frame.removeNotify(); 
  frame.setUndecorated(true);   
  frame.setResizable(false);
  frame.addNotify(); 
  frame.setLocation(0, 0);
  super.init();
}


//-----------------------------------------

public class secondApplet extends PApplet {
    public void setup() {
        size(640, 480);
        background(255);
    }
 
    public void draw() {
      
    }
}

//-----------------------------------------------------------------------------------------

