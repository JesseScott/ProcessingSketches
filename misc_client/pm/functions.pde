void containerReset() {

  int w = (projectorWidth-tmpWidth)/2;

  for (int i = 0; i < cons.length; i++) {

    cons[i].w = 50;
    cons[i].h = 50;

    cons[i].v2.x = 20+i*(tmpWidth)/cons.length+cons[i].w/2;
    cons[i].v2.y = 200+(i%2)*200;

    cons[i].v[0].x = 20+i*(tmpWidth)/cons.length+cons[i].w/2;
    cons[i].v[0].y = 200+(i%2)*200;
    cons[i].v[1].x = 20+i*(tmpWidth)/cons.length +cons[i].w+cons[i].w/2;
    cons[i].v[1].y = 200+(i%2)*200;
    cons[i].v[2].x = 20+i*(tmpWidth)/cons.length +cons[i].w+cons[i].w/2;
    cons[i].v[2].y = 200+(i%2)*200+cons[i].h;
    cons[i].v[3].x = 20+i*(tmpWidth)/cons.length +cons[i].w/2;
    cons[i].v[3].y = 200+(i%2)*200+cons[i].h;
    // pg[i] = createGraphics(cons[i].w, cons[i].h, P3D);
  }
}

void initGraphics() {
  for (int i = 0; i < cons.length; i++) {
    pg[i] = new GLGraphicsOffScreen(this,cons[i].w, cons[i].h);
    // pg[i] = createGraphics(cons[i].w, cons[i].h, JAVA2D);
  }
}


void pickRandomPreset() {
  int r = int(random(10));
  if(r== 0 )preset0();
  if(r== 1 )preset1();
  if(r== 2 )preset2();
  if(r== 3 )preset3();
  if(r== 4 )preset4();
  if(r== 5 )preset5();
  if(r== 6 )preset6();
  if(r== 7 )preset7();
  if(r== 8 )preset8();
  if(r== 9 )preset9();
}


void keyPressed() {

  if(!e6_textfield.isFocus()) { 
    if(key=='d')debug =!debug;
    if(key=='p')perspectiveMode =!perspectiveMode;
    if(key=='m')drawGUI =!drawGUI;
    if(!drawGUI)controlP5.hide();
    if(drawGUI)controlP5_2.show();
    if(!drawGUI)controlP5_2.hide();
    if(drawGUI)controlP5.show();
    if(key=='r')containerReset();
    if(key=='i') initGraphics();


    //saving positions
    if(key=='s') {
      String[] lines = new String[cons.length];
      for (int i = 0; i < cons.length; i++) {
        lines[i] =  (int)cons[i].v[0].x + ";" + (int)cons[i].v[0].y  + ";" +(int)cons[i].v[1].x + ";" + (int)cons[i].v[1].y  + ";" +(int)cons[i].v[2].x + ";" + (int)cons[i].v[2].y  + ";" +(int)cons[i].v[3].x + ";" + (int)cons[i].v[3].y + ";" + (int)cons[i].v2.x + ";" + (int)cons[i].v2.y + ";" + cons[i].w  + ";" + cons[i].h  ;
      }
      saveStrings("pos.txt", lines);
    }

    if(keyCode == UP)editNum++;
    if(keyCode == DOWN)editNum--;
    
    editNum = editNum%(cons.length+1);
    //preset 
    if(key=='y')controlP5.saveProperties("preset"+activePreset+".properties");


    if(key=='0')preset0();
    if(key=='1')preset1();
    if(key=='2')preset2();
    if(key=='3')preset3();
    if(key=='4')preset4();
    if(key=='5')preset5();
    if(key=='6')preset6();
    if(key=='7')preset7();
    if(key=='8')preset8();
    if(key=='9')preset9();

    //  for (int i = 0; i < 10; i++) {
    //    if(key==Character.forDigit(i, 10))controlP5.loadProperties("preset"+i+".properties");
    //    counter2.reset();
    //  }
  }
}

