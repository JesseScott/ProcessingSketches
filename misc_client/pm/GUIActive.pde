
void activeGUI() {

  //sorting order -------------
  for (int i = 0; i < cons.length; i++) {
    tmpIndex[i] = cons[i].v2.x;
  }
  tmpIndex = sort(tmpIndex);

  for (int i = 0; i < cons.length; i++) {
    for (int j = 0; j < cons.length; j++) {
      if(tmpIndex[i]==cons[j].v2.x)sortIndex[i]=j;
    }
  }

  //changing position dropdown by order
  for (int i = 0; i < dd.length; i++) {
    int x = cons[sortIndex[i]].index;

    dd[x].setPosition(int(GUIPosX+i*(prevBarWidth+5)),GUIPosY);
  }

  pushMatrix();
    translate( prevBarX,prevBarY);
    noStroke();
    float prevScale = 0.5;
  
    for (int j = 0; j < cons.length; j++) { 
      fill(40);
      int i = sortIndex[j];
  
      float w = prevBarWidth;
      float h = prevBarWidth/cons[i].w * cons[i].h ;
  
      rect(0,-h,w,h);
      fill(220);
      //text(cons[i].index,8,20);
      image(pg[i].getTexture(),0,-h,w,h);
      translate(w+5,0);
    }
  popMatrix();

  //random change check
  if(checkbox.getState() && randomSec<=(counter2.second()+counter2.minute()*60+counter2.hour()*3600))
    pickRandomPreset();

  // Graphic Elements
  stroke(30);
  line(prevBarX-2,prevBarY+30,dd.length*(prevBarWidth+ 5)+prevBarX-2,prevBarY+30);
  line(prevBarX-2,prevBarY+81,dd.length*(prevBarWidth+ 5)+prevBarX-2,prevBarY+81);

  // timer
  text(counter1.toString(),GUIPosX,GUIPosY+30);
  text(counter2.toString(),GUIPosX,GUIPosY+50);
}

