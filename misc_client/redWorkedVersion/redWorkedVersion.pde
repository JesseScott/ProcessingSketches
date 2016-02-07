
// IMPORTS
//!!!! CHANGED AUDIO TO MINIM
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.effects.*;
import JMyron.*;  
import oscP5.*;
import netP5.*;

// DECLARATIONS
VehicleController vehicleController;
FloatVehicle floatVehicle;
JMyron m;
Minim minim;
AudioOutput out;
WhiteNoise wn;
OscP5 oscP5;
XMLElement xml;

// VARIABLES
//variables to maintain the floating green circle for camera mouse
float xDiff = 0;
float yDiff = 0;
float objx = 160;
float objy = 120;
float objdestx = 160;
float objdesty = 120; 

//xml
int port;
String ip;
//osc
float recBlobNum, recBlobSize;
  
 void setup() {
    size(screen.width/2,screen.height/2, P3D);
    background(20);
    frameRate(120);
    noStroke();
    
    vehicleController = new VehicleController(100);
    floatVehicle = new FloatVehicle(1);
    
    // JMyron
    m = new JMyron();//make a new instance of the object
    m.start(320,240);//start a capture at 320x240
    m.trackColor(255,255,255,256*3-100); //track white
    m.update();
    m.adaptivity(50);
    m.adapt();// immediately take a snapshot of the background for differencing

    // !!!! SETUP AND INSTANTIATE WHITE NOISE IN MINIM
    // Minim Declaration & Setup
    minim = new Minim(this);
    out = minim.getLineOut(Minim.STEREO, 1024);
    wn = new WhiteNoise(0.1);
    out.addSignal(wn);
    
      // XML
    xml = new XMLElement(this, "data/networkSetup.xml");
    XMLElement kid1 = xml.getChild("port");
    XMLElement kid2 = xml.getChild("ip");
    port = Integer.parseInt(kid1.getContent());  
    println("PORT " + port);
    ip = kid2.getString("address");
    println("IP " + ip);
    // OSC
    oscP5 = new OscP5(this, port);

  }
  


 void draw() {

    //JMyron
    m.update(); //update the camera view
    int[][] centers = m.globCenters(); //get the center points
    //draw all the dots while calculating the average.
    float avX = 0;
    float avY = 0;
    for(int i = 0;i < centers.length;i++){
      fill(80);
      avX += centers[i][0]/320.0*screen.width;
      avY += centers[i][1]/240.0*screen.height;
    }
    if(centers.length-1>0){
      avX /= centers.length-1;
      avY /= centers.length-1;
    }
    //update the location of the thing on the screen.
    if(!(avX == 0 && avY == 0) && centers.length > 0){
      objdestx = avX;
      objdesty = avY;
    }

    objx += (objdestx-objx) / 10.0f;
    objy += (objdesty-objy) / 10.0f;

    //xSpeed and ySpeed are the speed an object in the camera as it moves
    float xSpeed = floor(sqrt(sq(objx - xDiff)));
    float ySpeed = floor(sqrt(sq(objy - yDiff)));

    //The code for James's example - Myron_CameraAsMouse_mod_james.pde finshes
    if(xSpeed > 10){
      // ???
    }
    
    xDiff = objx;
    yDiff = objy;
    
    //Volume
    float fvol = objy / float(height); // sets location of objects
    float vol = constrain(1.15 / fvol, fvol, fvol*2 ); // sets volume levels for 
    wn.setAmp(vol); // White Noise Volume

    // State
    int recState = round(recBlobNum);
    floatVehicle.setState(recState);
    floatVehicle.cycle();
    vehicleController.cycle();
    //vehicleController.draw(floatVehicle);
  }


/* calculate the rotation by the velocity vector */
float getNORMALRotation(Vector3f velocity) {
  return atan2(velocity.z, velocity.x);
}

// !!! CLOSE AUDIO CHANNEL
void stop() {
  // Close Minim
  out.close();
  minim.stop();
  // Close JMyron
  m.stop();
  super.stop();
}



