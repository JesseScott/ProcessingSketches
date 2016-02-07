
//-----------------------------------------------------------------


//-------------

void Mode_5() {
  // AUDIO REACTION
  pushStyle();    
  pushMatrix();
  
  // Screen
  background(0);
  noFill();
  stroke(255, 100);
  
  // Style
  strokeWeight(0.25);
  
  // Analyze Audio
  
  // Draw
  for(int i = 0; i < in.bufferSize() - 1; i += 8 ) {
    stroke(i, i);
    triangle(in.left.get(i) * 250, height/2 - i, width/2, i, width/2, i);
    triangle(width/2, i, width - in.right.get(i) * 250, i, width/2, i);
    triangle(width/2, height - i, width - in.right.get(i) * 250, height, width/2, i);
    triangle(in.right.get(i) * 250, height - i, width/2, height -i, width/2, i);    
  }
  

  

  popMatrix();
  popStyle();
}



//-----------------------------------------------------------------

