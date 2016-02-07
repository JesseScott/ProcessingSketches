
String date;

void setup() {
  String tempDate[] = loadStrings("dates.txt");
  if(month() == 5) {
    if( day() <= 28) {
      date = tempDate[0]; 
    }
    else {
      date = tempDate[1]; 
    }
  }

  else if(month() == 6) {
    if( day() <= 18) {
      date = tempDate[1];
    } 
    else {
      date = tempDate[2]; 
    }
  }
  
  else if(month() == 7) {
    if( day() <= 30) {
      date = tempDate[2];
    } 
    else {
      date = tempDate[3]; 
    }
  }

  else if(month() == 8) {
    if( day() <= 27) {
      date = tempDate[3];
    } 
    else {
      date = tempDate[4]; 
    }
  }
  
  else if(month() == 9) {
    if( day() <= 24) {
      date = tempDate[4];
    } 
    else {
      date = tempDate[5]; 
    }
  }
  
  else if(month() == 10) {
    if( day() <= 29) {
      date = tempDate[5];
    } 
    else {
      date = tempDate[5]; 
    }
  }
  
  println(date);
} 

