// http://www.freebase.com/view/military/views/military_conflict

void setup() {

   String lines[] = loadStrings("http://www.freebase.com/view/military/views/military_conflict"); 
   println(lines.length);
   for(int i = 0 ; i < lines.length-1 ; i++) {
     println(lines[i]); 
   }

  
}

