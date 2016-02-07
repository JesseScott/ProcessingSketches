import java.awt.*;

int x1 = 100;
int y1 = 100;
int x2 = 300;
int y2 = 100;
int x3 = 200;
int y3 = 300;


void setup() {
  size(400, 400);
  
}

void draw() {
  triangle(x1, y1, x2, y2, x3, y3);
  //isMouseOverTri(mouseX, mouseY);
  isInsideTriangle(x1, y1, x2, y2, x3, y3, mouseX, mouseY);

}
public boolean isInsideTriangle(int x1,int y1,int x2,int y2,int x3,int y3,int x4,int y4) {
    Polygon p = new Polygon(new int[]{x1,x2,x3},new int[]{y1,y2,y3},3);
    if(p.contains(x4,y4)) {
      println("TRYUE");
      return true; 
    }
    else {
      return false;
    }
}
  


void isMouseOverTri(int x, int y) {
  x = mouseX;
  y = mouseY;
  
  float a = atan2(x, x1);
  float b = atan2(x, x2);
  float c = atan2(x, x3);
  float d = atan2(y, y1);
  float e = atan2(y, y2);
  float f = atan2(y, y3);
  float sum = a + b + c + d + e +f;
  float deg = degrees(sum);
  println(sum + " " + deg);
  
}


