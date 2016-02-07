
//-----------------------------------------------------------------

void enableVSync() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  javax.media.opengl.GL gl = pgl.beginGL();
  gl.setSwapInterval(1);
  pgl.endGL();
}


//-----------------------------------------------------------------

class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioInput source;
  
  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

//-----------------------------------------------------------------

void drawingMode() {
  if(drawMode == 1) Mode_1();
  if(drawMode == 2) Mode_2();
  if(drawMode == 3) Mode_3();
  if(drawMode == 4) Mode_4();
  if(drawMode == 5) Mode_5();
  //if(drawMode == 6) Mode_6();
  //if(drawMode == 7) Mode_7();
  //if(drawMode == 8) Mode_8();
  //if(drawMode == 9) Mode_9();  
}

//----------

void keyPressed() {
  if(key != CODED) {
    background(0);
    if(keyCode == '1') drawMode = 1;
    if(keyCode == '2') drawMode = 2;
    if(keyCode == '3') drawMode = 3;
    if(keyCode == '4') drawMode = 4;
    if(keyCode == '5') drawMode = 5;
    if(keyCode == '6') drawMode = 6;
    if(keyCode == '7') drawMode = 7;
    if(keyCode == '8') drawMode = 8;
    if(keyCode == '9') drawMode = 9;
  }
}

//-----------------------------------------------------------------

