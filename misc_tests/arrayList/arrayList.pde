

String word = " ";

void setup() {
 size(400, 400);
 background(0);
}

void draw() {
  String [] Sentence = splitTokens(word, "\r");
  for(int i = 0; i < Sentence.length; i++) {
    println("S1 " + Sentence[i]);  
  }
}

void keyTyped() {
 if (key == ENTER) {  
  }  
  word += key;
}

