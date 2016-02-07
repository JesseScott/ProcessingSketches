void setup() {
  String s1,s2,s3,s4,s5,s6,s7,s8,s9;
  int NumScreens;
  int FirstScreenWidth, FirstScreenHeight, FirstScreenOffset;   
  int SecondScreenWidth, SecondScreenHeight, SecondScreenOffset;
  int ThirdScreenWidth, ThirdScreenHeight, ThirdScreenOffset;
  
  String settings[]  =  loadStrings("settings.txt");
  s1  =  settings[0];
  s2  =  settings[1];
  s3  =  settings[2];
  s4  =  settings[3];
  s5  =  settings[4];
  s6  =  settings[5];
  s7  =  settings[6];
  s8  =  settings[7];
  s9  =  settings[8];
 
  for(int i = 0; i < settings.length; i++) {
    println(settings[i]);
    String[] values = String(split(settings[i],"="));
  }
  

  
}
