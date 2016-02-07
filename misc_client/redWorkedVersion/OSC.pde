
public void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/blob") && msg.checkTypetag("ff")) {
    recBlobNum = msg.get(0).floatValue();  
    recBlobSize = msg.get(1).floatValue(); 
    println(" Received Values: " + recBlobNum + ", " + recBlobSize);
  }
  
}
