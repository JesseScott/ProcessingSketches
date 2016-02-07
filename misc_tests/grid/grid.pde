

int col1 = color(90, 100, 75);
int col2 = color(207, 91, 73);
int col3 = color(242, 130, 64);
int col4 = color(167, 201, 136);
int col5 = color(224, 30, 110);
int col6 = color(229, 157, 132);
int col7 = color(126, 93, 59);
int col8 = color(237, 90, 45);
int col9 = color(0, 89, 174);
int col10 = color(106, 74, 46);
int col11 = color(255, 208, 45);
int col12 = color(162, 154, 144);
int col13 = color(86, 143, 116);
int col14 = color(15, 89, 70);
int col15 = color(170, 19, 62);

int grid[] = {  1, 2, 3, 4, 5, 6, 7, 8,
                9, 10, 11, 12, 13, 14, 15, 16,
                17, 18, 19, 20, 21, 22, 23, 24, 
                25, 26, 27, 28, 29, 30, 31, 32,
                33, 34, 35, 36, 37, 38, 39, 40, 
                41, 42, 43, 44, 45, 46, 47, 48,
                49, 50, 51, 52, 53, 54, 55, 56,
                57, 58, 59, 60, 61, 62, 63, 64 };
                

void setup() {
  size(512,512);
  background(255);
  stroke(0);
  smooth();
  
}

void draw() {

  int g = width / 16; 
  int h = height / 32;

  for( int j = 0; j < width; j += g) {
     line(0, j, width, j); 
     line(j, 0, j, height);
     
     for( int i = 1; i < 9; i++) {
       println(i);
       ellipse(h + j, h, g, g);
     }
  }


    
}
