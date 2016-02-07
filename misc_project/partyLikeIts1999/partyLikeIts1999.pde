import wordookie.*;
java.util.List wordList;

static String FONT = "Serif";
static final float maxFont = 100f;
static final float minFont = 12f;
static color [] textColors = {#F6EFF7, #BDC9E1, #67A9CF, #02818A};
color bg = color(0);

String word = " ";
//String [] Sentence;
int wordIndex = 0;
PFont font;
Layout layout;

void setup() {
 size(400, 400);
 background(0);
 smooth();
 
 font = createFont(FONT, 48);

 layout = new Layout(this, bg); 
}

void draw() {
  loadWords();
  sortWords(); 
  
  if(wordIndex < wordList.size() ) {
   Word word = (Word)wordList.get(wordIndex);
   word.font = font; 
   layout.doLayout(word);
   fill(textColors[(int)random(textColors.length)]);
   layout.paintWord(word);
   wordIndex++;
  }
  else {
   //println("Done");
   //noLoop(); 
  }
}

void loadWords() {
  wordList = new ArrayList();
  String [] Sentence = splitTokens(word, "\r");
  println("SENT " + Sentence);
  for(int i = 0; i < Sentence.length; i++) { 
   Word w = new Word(Sentence[i]); 
   println("w " + w);
   wordList.add(w); 
  }
}

void sortWords() {
  Collections.sort(wordList);
  float greatestWeight = ( (Word)wordList.get(0) ).weight;
  float leastWeight = ( (Word)wordList.get(wordList.size() -1)).weight;
  for(int i = 0; i < wordList.size(); i++) {
  Word w = (Word)wordList.get(i);
  w.fontSize = (int)map(w.weight, leastWeight, greatestWeight, minFont, maxFont); 
  }
}

void keyTyped() {
 word += key;
 println("Word " + word);
}

