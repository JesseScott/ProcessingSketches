int S=500, N= 200, o=S/2, i= 4, r;
float s= TWO_PI/N;
PVector[] T;

void setup () {
      size (S,S);
      smooth ();
      T = new PVector[N];
      for (int n=0; n<N; n++) T[n] = new PVector (cos (n*s), sin (n*s));
}

void draw () {
      for  (int p=0, j=p+1, r1, r2; p<N; p++, j=(p+1)%N) {
      r1=r2=r;     
      if (random(1)<.5) r1=r+i; else r2=r+i;
      line ( o+T[p].x*r1, o+T[p].y*r1, o+T[j].x*r2, o+T[j].y*r2 ); 
      }
      r+=i;
}

