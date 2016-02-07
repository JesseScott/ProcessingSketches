//-----------------------------------------------------------------

public void oscEvent(OscMessage msg) {
  //msg.print();
  if (msg.checkAddrPattern("/pitch") && msg.checkTypetag("f")) {
    pitchValue = msg.get(0).floatValue();
    //println("Pitch Received of " + pitchValue);
  }
  if (msg.checkAddrPattern("/attack") && msg.checkTypetag("i")) {
    attackValue = msg.get(0).intValue();
    //println("Attack Received of " + attackValue);
  }
  if(msg.checkAddrPattern("/level") && msg.checkTypetag("f")) {
    levelValue = msg.get(0).floatValue();
    //println("Level Received of " +  levelValue);
  }

  //print("### received an osc message.");
  //print(" addrpattern: " + msg.addrPattern());
  //println(" typetag: " + msg.typetag());
 
}

//-----------------------------------------------------------------



