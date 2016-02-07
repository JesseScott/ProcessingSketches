
class Container {
  
  PVector[] v = new PVector[4];
  PVector v2;
  int handleSize = 10; // size of handles to 
  boolean drag = false;
  float meshRes;
  int index;
  int hideTrans = 0;
  int w,h;
  boolean mirrorY;   
  boolean mirrorX;     
  boolean flip180;  

  Container(float x0, float y0,float x1, float y1,float x2, float y2,float x3, float y3,float xv2, float yv2,int _w, int _h, int _index) {

    v[0] = new PVector(x0, y0);
    v[1] = new PVector(x1, y1);
    v[2] = new PVector(x2, y2);
    v[3] = new PVector(x3, y3);
    v2 = new PVector(xv2,yv2); 

    w = _w;
    h = _h;
    index = _index;
    meshRes = 6;

    mirrorY = false;   
    mirrorX = false;     
    flip180 = false;
  }
  
  //
  void drag() {
    winGraphics.rectMode(CENTER);
    
    for(int i = 0; i<4;i++) {
      winGraphics.stroke(255);
      if(over(v[i].x,v[i].y)) {
        winGraphics.stroke(255,0,0);
        if(mousePressed) {
          v[i].x=mouseX;
          v[i].y=mouseY;
        }
      }
      winGraphics.rect(v[i].x,v[i].y,handleSize,handleSize);
    }

    if(over(v[0].x-20,v[0].y)) {
      winGraphics.stroke(255);
      for(int i = 0; i<4;i++) {
        if(mousePressed) {
          v[i].x+=mouseX-pmouseX;
          v[i].y+=mouseY-pmouseY;
        }
      }
      winGraphics.stroke(255,0,0);
    } 
    winGraphics.ellipse(v[0].x-20,v[0].y,10,10);
    winGraphics.rectMode(CORNER);
  }
  
  //
  void drag2() {
    winGraphics.rectMode(CENTER);

    // box handles
    if(over(v2.x+w/2,v2.y+h)) {
      winGraphics.stroke(255,0,0);
      if(mousePressed) {
        h+=mouseY-pmouseY;
        //pg[index] = createGraphics(w, h, JAVA2D);
      }
    }  
    winGraphics.rect(v2.x+w/2,v2.y+h,handleSize,handleSize);
    winGraphics.text(h,v2.x+w/2-textWidth(Integer.toString(h))/2,v2.y+h+25);
    winGraphics.stroke(255);

    if(over(v2.x+w,v2.y+h/2)) {
      winGraphics.stroke(255,0,0);
      if(mousePressed) {
        w+=mouseX-pmouseX;
        // pg[index] = createGraphics(abs(w), abs(h), JAVA2D);
      }
    }  
    winGraphics.rect(v2.x+w,v2.y+h/2,handleSize,handleSize);
    winGraphics.text(w,v2.x+w+15,v2.y+h/2+5);
    winGraphics.stroke(255);

    if(over(v2.x-20,v2.y)) {
      winGraphics.stroke(255);
      if(mousePressed) {
        v2.x+=mouseX-pmouseX;
        v2.y+=mouseY-pmouseY;
      }
      winGraphics.stroke(255,0,0);
    } 
    winGraphics.ellipse(v2.x-20,v2.y,10,10);
    winGraphics.rectMode(CORNER);
  }

  //
  void render() {

    if(debug) {
      winGraphics.fill(255);
      winGraphics.stroke(255);
      if(editNum == index)winGraphics.stroke(255,0,0);
      if(perspectiveMode)winGraphics.text(index,v[0].x-24,v[0].y-20);
      if(!perspectiveMode)winGraphics.text(index,v2.x-24,v2.y-20);
    }

    winGraphics.fill(100);
    if(perspectiveMode) {
      winGraphics.stroke(255,70);
      if(!debug)winGraphics.noStroke();
      if(editNum == index && debug)winGraphics.stroke(255,0,0);
      winGraphics.beginShape(QUADS);
        // Set the Effect Texture to the Rectangles   
        winGraphics.texture(pg[index].getTexture());
        for(int i=0; i<meshRes; i++) {
          for(int j=0; j<meshRes; j++) {
            subdivide( i/meshRes, j/meshRes);
            subdivide( (i+1)/meshRes, j/meshRes);
            subdivide( (i+1)/meshRes, (j+1)/meshRes);
            subdivide( i/meshRes, (j+1)/meshRes);
          }
        }
      winGraphics.endShape();
      if(!hideEffekt.getState())hideTrans = 0;
      if(globalStrokeOn.getState() || hideEffekt.getState() ) {
        winGraphics.strokeWeight(5);
        winGraphics.stroke(255);
        if(soundStroke.getState())winGraphics.stroke(255,hatSize*255);
        if(!globalStrokeOn.getState())winGraphics.noStroke();
        winGraphics.noFill();
        if(hideEffekt.getState())winGraphics.fill(0,constrain(hideTrans+=5,0,255));
        // Set the Rectangles
        winGraphics.beginShape();   
          winGraphics.vertex(v[0].x,v[0].y);
          winGraphics.vertex(v[1].x,v[1].y);
          winGraphics.vertex(v[2].x,v[2].y);
          winGraphics.vertex(v[3].x,v[3].y);
        winGraphics.endShape(CLOSE);
        winGraphics.noStroke();  
        winGraphics.strokeWeight(1);
      }
    }
    else {
      //      fill(255,0,0);
      //      rect(v[0].x,v[0].y,w,h);
      winGraphics.pushMatrix();
        winGraphics.translate(v2.x,v2.y);
        winGraphics.noFill();
        winGraphics.fill(255,20);
        winGraphics.image(pg[index].getTexture(),0,0,w,h);
        winGraphics.rect(0,0,w,h);
      winGraphics.popMatrix();
      winGraphics.fill(100);
    }
  }

  //
  void subdivide(float xx, float yy) {
    float xx2;
    float yy2;        
    float bx ;
    float yy3;   

    if(mirrorX) {
      xx2 = v[2].x + (v[3].x - v[2].x)*xx;
      yy2 = v[2].y + (v[3].y - v[2].y)*xx;        
      bx = v[1].x + (v[0].x - v[1].x)*xx;
      yy3 = v[1].y + (v[0].y - v[1].y)*xx;
    } 
    else if(mirrorY) {
      xx2 = v[1].x + (v[0].x - v[1].x)*xx;
      yy2 = v[1].y + (v[0].y - v[1].y)*xx;        
      bx = v[2].x + (v[3].x - v[2].x)*xx;
      yy3 = v[2].y + (v[3].y - v[2].y)*xx;
    }    
    else {
      xx2 = v[0].x + (v[1].x - v[0].x)*xx;
      yy2 = v[0].y + (v[1].y - v[0].y)*xx;        
      bx = v[3].x + (v[2].x - v[3].x)*xx;
      yy3 = v[3].y + (v[2].y - v[3].y)*xx;
    }

    winGraphics.vertex(xx2 + (bx - xx2) * yy, yy2 + (yy3 - yy2) * yy, xx* w, yy* h);
    //        textSize(14);
    //        fill(255);
    //        text(xx+":"+yy,+xx2 + (bx - xx2) * yy, yy2 + (yy3 - yy2) * yy);
    //        fill(30);
    //        ellipse(xx2 + (bx - xx2) * yy, yy2 + (yy3 - yy2) * yy,10,10);
  }

  //
  boolean over(float x, float y) { 
    if( pmouseX > x - handleSize && pmouseX < x + handleSize && pmouseY > y - handleSize && pmouseY < y + handleSize && editNum == index ) 
    { 
      return true;
    } 
    else
    {      
      return false;
    }
  }
}

