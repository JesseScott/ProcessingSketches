
//-----------------------------------------------------------------------------------------

public void oscEvent(OscMessage msg) {
  
  if(msg.checkAddrPattern("/andAcc") && msg.checkTypetag("fff")) {
    xyz[0] = msg.get(0).floatValue();  
    xyz[1] = msg.get(1).floatValue(); 
    xyz[2] = msg.get(2).floatValue(); 
    println(" Accel Values: " + xyz[0] + ", " + xyz[1] + ", " + xyz[2]);
  }
  else if(msg.checkAddrPattern("/andColor") && msg.checkTypetag("i")) {
    picker = msg.get(0).intValue();  
    println(" Color Values: " + picker);
  }
  else if(msg.checkAddrPattern("/andPress") && msg.checkTypetag("i")) {
    touch = msg.get(0).intValue();  
    println(" Touch: " + touch);
  }
 
} //--

//-----------------------------------------------------------------------------------------

