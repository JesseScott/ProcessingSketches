int e1_R = 0;
int e1_G = 0;
int e1_B = 0;

int e1_R2 = 0;
int e1_G2 = 0;
int e1_B2 = 0;

int newR, newG, newB;
float boolPulse;

int e1_ALPHA = 255;

int e1_stroke = 1;
int e1_depth = 1;
int e1_speed = 1;

Toggle e1_tl,e1_tr,e1_ml,e1_mr, e1_flash, e1_boolPulse;
Toggle e1_rPulse, e1_gPulse, e1_bPulse;
RadioButton e1_radio;

void initE1GUI() {
  
  controlP5.addSlider("e1_R",00,255,128,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("e1_R").moveTo("0");
  controlP5.addSlider("e1_G",00,255,128,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("e1_G").moveTo("0");
  controlP5.addSlider("e1_B",00,255,128,TabsPosX,TabsPosY+60,100,10);
  controlP5.controller("e1_B").moveTo("0");
  controlP5.addSlider("e1_ALPHA",00,255,255,TabsPosX,TabsPosY+80,100,10);
  controlP5.controller("e1_ALPHA").moveTo("0");
  
  e1_rPulse = controlP5.addToggle("R+PULSE",true,TabsPosX+130,TabsPosY+20,10,10);
  e1_rPulse.captionLabel().style().marginTop = -13;
  e1_rPulse.captionLabel().style().marginLeft = 13;
  e1_rPulse.moveTo("0");
  
  e1_gPulse = controlP5.addToggle("G+PULSE",true,TabsPosX+130,TabsPosY+40,10,10);
  e1_gPulse.captionLabel().style().marginTop = -13;
  e1_gPulse.captionLabel().style().marginLeft = 13;
  e1_gPulse.moveTo("0");
  
  e1_bPulse = controlP5.addToggle("B+PULSE",true,TabsPosX+130,TabsPosY+60,10,10);
  e1_bPulse.captionLabel().style().marginTop = -13;
  e1_bPulse.captionLabel().style().marginLeft = 13;
  e1_bPulse.moveTo("0");

  controlP5.addSlider("e1_R2",00,255,0,TabsPosX,TabsPosY+100,100,10);
  controlP5.controller("e1_R2").moveTo("0");
  controlP5.addSlider("e1_G2",00,255,0,TabsPosX,TabsPosY+120,100,10);
  controlP5.controller("e1_G2").moveTo("0");
  controlP5.addSlider("e1_B2",00,255,0,TabsPosX,TabsPosY+140,100,10);
  controlP5.controller("e1_B2").moveTo("0");

  controlP5.addSlider("e1_stroke",1,5,1,TabsPosX+250,TabsPosY+20,50,10);
  controlP5.controller("e1_stroke").moveTo("0");
  
  e1_radio = controlP5.addRadioButton("e1_radio",TabsPosX+200,TabsPosY+60);
  addToRadioButton(e1_radio,"DEPTH",1);
  addToRadioButton(e1_radio,"GRID",2);
  e1_radio.setNoneSelectedAllowed(false);
  e1_radio.moveTo("0");
  e1_radio.setSpacingRow(10);
  
  e1_flash = controlP5.addToggle("FLASH",true,TabsPosX+200,TabsPosY+40,10,10);
  e1_flash.captionLabel().style().marginTop = -13;
  e1_flash.captionLabel().style().marginLeft = 13;
  e1_flash.moveTo("0");
  
  e1_boolPulse = controlP5.addToggle("PULSE",true,TabsPosX+200,TabsPosY+20,10,10);
  e1_boolPulse.captionLabel().style().marginTop = -13;
  e1_boolPulse.captionLabel().style().marginLeft = 13;
  e1_boolPulse.moveTo("0");
  
  controlP5.addSlider("e1_depth",1,8,1,TabsPosX+250,TabsPosY+60,50,10);
  controlP5.controller("e1_depth").moveTo("0");

  controlP5.addSlider("e1_speed",1,6,3,TabsPosX+250,TabsPosY+40,50,10);
  controlP5.controller("e1_speed").moveTo("0");

  e1_tl = controlP5.addToggle("TL",true,TabsPosX+200,TabsPosY+100,15,15);
  e1_tl.captionLabel().style().marginTop = -15;
  e1_tl.captionLabel().style().marginLeft = 20;
  e1_tl.moveTo("0");
  
  e1_ml = controlP5.addToggle("ML",true,TabsPosX+200,TabsPosY+120,15,15);
  e1_ml.captionLabel().style().marginTop = -15;
  e1_ml.captionLabel().style().marginLeft = 20;
  e1_ml.moveTo("0");
  
  e1_tr = controlP5.addToggle("TR",true,TabsPosX+235,TabsPosY+100,15,15);
  e1_tr.captionLabel().style().marginTop = -15;
  e1_tr.captionLabel().style().marginLeft = 20;
  e1_tr.moveTo("0");
  
  e1_mr = controlP5.addToggle("MR",true,TabsPosX+235,TabsPosY+120,15,15);
  e1_mr.captionLabel().style().marginTop = -15;
  e1_mr.captionLabel().style().marginLeft = 20;
  e1_mr.moveTo("0");
  
}
 
       
 void effect01(int index) {  
       pg[index].beginDraw();
       
       float pulse = map(in.mix.level(), 0, 1, 0, 255);
       
       if(e1_rPulse.getState() == true) {
        int roundPulse = round(pulse);
        newR = e1_R+roundPulse;
       } else {
         newR = e1_R;
       }
       if(e1_gPulse.getState() == true) {
        int roundPulse = round(pulse);
        newG = e1_G+roundPulse;
       } else {
         newG = e1_G;
       }
       if(e1_bPulse.getState() == true) {
        int roundPulse = round(pulse);
        newB = e1_B+roundPulse;
       } else {
         newB = e1_B;
       }
       if(e1_boolPulse.getState() == true) {
        boolPulse = pulse;
       } else {
         boolPulse = 0;
       }
              
       pg[index].strokeWeight(e1_stroke);
       pg[index].stroke(newR,newG,newB,e1_ALPHA); 
       pg[index].background(e1_R2,e1_G2,e1_B2);
       pg[index].smooth();
       pg[index].noFill(); 
       
       if(e1_radio.getState(0) == true) { // Depth
         pg[index].translate(cons[index].w/2, cons[index].h/2);
         int h =  cons[index].h;
         int w =  cons[index].w;
           for(int i = 0; i < e1_depth; i++) {
             if(e1_flash.getState() == true) {
               pg[index].stroke(newR,newG,newB,e1_ALPHA); 
               if((frameCount/(e1_speed*10))%e1_depth == i) pg[index].stroke(255); 
               }
                 pg[index].box( w, h, boolPulse);
                 w-=cons[index].w/e1_depth;
                 h-=cons[index].h/e1_depth;
               }  
             
       } // end Depth
       else if (e1_radio.getState(1) == true) { // Box
       
         pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
         
         if(e1_tl.getState() == true && e1_tr.getState() == false) { // TL on TR off
           if (e1_ml.getState() == false && e1_mr.getState() == true) { // BL off BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TL
             pg[index].translate(cons[index].w *0.45, cons[index].h *0.4);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BR
             popMatrix();
           }
           else if (e1_ml.getState() == true && e1_mr.getState() == true) { // BL on BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TL
             pg[index].translate(0, cons[index].h *0.45);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BL
             pg[index].translate(cons[index].w *0.45, 0);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BR
             popMatrix();
           }
          else if (e1_ml.getState() == true && e1_mr.getState() == false) { //BL on BR off
            pushMatrix();
            pg[index].translate(cons[index].w *0.35, cons[index].h *0.15);
            pg[index].box(cons[index].w *0.7, cons[index].h *0.3, pulse); // TL
            pg[index].translate(0, cons[index].h *0.45);
            pg[index].box(cons[index].w *0.7, cons[index].h *0.3, pulse); // BL
            popMatrix();
          }
          else if (e1_ml.getState() == false && e1_mr.getState() == false) { //BL off BR off
            pushMatrix();
            pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TL
            popMatrix();
          }
         }
          
         else if(e1_tl.getState() == false && e1_tr.getState() == true) { // TL off TR on
           if (e1_ml.getState() == false && e1_mr.getState() == true) { // BL off BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.35, cons[index].h *0.15);
             pg[index].box(cons[index].w *0.7, cons[index].h *0.3, pulse); // TR
             pg[index].translate(0, cons[index].h *0.45);
             pg[index].box(cons[index].w *0.7, cons[index].h *0.3, pulse); // BL
             popMatrix();
           }
           else if (e1_ml.getState() == true && e1_mr.getState() == true) { // BL on BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.15, cons[index].h *0.6);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BL
             pg[index].translate(cons[index].w *0.45, 0);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BR
             pg[index].translate(0, 0-cons[index].h *0.45);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TR
             popMatrix();
           }
          else if (e1_ml.getState() == true && e1_mr.getState() == false) { //BL on BR off
            pushMatrix();
             pg[index].translate(cons[index].w *0.15, cons[index].h *0.6);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BL
             pg[index].translate(cons[index].w *0.45, 0-cons[index].h *0.45);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TR            
            popMatrix();
          }
          else if (e1_ml.getState() == false && e1_mr.getState() == false) { //BL off BR off
            pushMatrix();
            pg[index].translate(cons[index].w *0.45, cons[index].h *0.15);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TR
            popMatrix();
          }
        }
        else if(e1_tl.getState() == true && e1_tr.getState() == true) { // TL off TR on
           if (e1_ml.getState() == false && e1_mr.getState() == true) { // BL off BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TL
             pg[index].translate(cons[index].w *0.45, 0);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TR
             pg[index].translate(0, cons[index].h *0.45);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BR
             popMatrix();
           }
           else if (e1_ml.getState() == true && e1_mr.getState() == true) { // BL on BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TL
             pg[index].translate(cons[index].w *0.45, 0);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TR
             pg[index].translate(0, cons[index].h *0.45);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BR
             pg[index].translate(0-cons[index].w *0.45, 0);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BL
             popMatrix();
           }
          else if (e1_ml.getState() == true && e1_mr.getState() == false) { //BL on BR off
            pushMatrix();
            pg[index].translate(cons[index].w *0.15, cons[index].h *0.15);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TL
            pg[index].translate(cons[index].w *0.45, 0);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // TR
            pg[index].translate(0-cons[index].w *0.45, cons[index].h *0.45);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BL
            popMatrix();
          }
          else if (e1_ml.getState() == false && e1_mr.getState() == false) { //BL off BR off
            pushMatrix();
            pg[index].translate(cons[index].w *0.15, cons[index].h *0.35);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.7, pulse); // TL
            pg[index].translate(cons[index].w *0.45, 0);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.7, pulse); // TR
            popMatrix();
          }
        }
        else if(e1_tl.getState() == false && e1_tr.getState() == false) { // TL off TR on
           if (e1_ml.getState() == false && e1_mr.getState() == true) { // BL off BR on
             pushMatrix();
             pg[index].translate(cons[index].w *0.65, cons[index].h *0.6);
             pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BR
             popMatrix();
           }
           else if (e1_ml.getState() == true && e1_mr.getState() == true) { // BL on BR on
             pushMatrix();
            pg[index].translate(cons[index].w *0.15, cons[index].h *0.35);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.7, pulse); // BL
            pg[index].translate(cons[index].w *0.45, 0);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.7, pulse); // BR
             popMatrix();
           }
          else if (e1_ml.getState() == true && e1_mr.getState() == false) { //BL on BR off
            pushMatrix();
            pg[index].translate(cons[index].w *0.15, cons[index].h *0.6);
            pg[index].box(cons[index].w *0.3, cons[index].h *0.3, pulse); // BL
            popMatrix();
          }
          else if (e1_ml.getState() == false && e1_mr.getState() == false) { //BL off BR off
            pushMatrix();

            popMatrix();
          }        
        }  
       } // end Box
       pg[index].endDraw();
 } // end 01
