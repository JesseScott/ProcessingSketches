// Functions to handle sorting the color data

void sort(int length, int[] a, Tuple[] stuff) {
  sortSub(a, stuff, 0, length - 1);
}

void sortSwap(int[] a, Tuple[] stuff, int i, int j) {
  int T = a[i];
  a[i] = a[j];
  a[j] = T;

  Tuple v = stuff[i];
  stuff[i] = stuff[j];
  stuff[j] = v;
}

void sortSub(int[] a, Tuple[] stuff, int lo0, int hi0) {
  int lo = lo0;
  int hi = hi0;
  int mid;

  if (hi0 > lo0) {
    mid = a[(lo0 + hi0) / 2];

    while (lo <= hi) {
      while ((lo < hi0) && (a[lo] < mid)) {
        ++lo;
      }
      while ((hi > lo0) && (a[hi] > mid)) {
        --hi;
      }
      if (lo <= hi) {
        sortSwap(a, stuff, lo, hi);
        ++lo;
        --hi;
      }
    }

    if (lo0 < hi)
      sortSub(a, stuff, lo0, hi);

    if (lo < hi0)
      sortSub(a, stuff, lo, hi0);
  }
}

// Simple vector class that holds an x,y,z position.

class Tuple {
  float x, y, z;

  Tuple() { }

  Tuple(float x, float y, float z) {
    set(x, y, z);
  }

  void set(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void target(Tuple another, float amount) {
    float amount1 = 1.0 - amount;
    x = x*amount1 + another.x*amount;
    y = y*amount1 + another.y*amount;
    z = z*amount1 + another.z*amount;
  }
  
  void phil() {
    fill(x, y, z);
  }
}

