import CiSlib.*;

double S = 0.01; // speed constant

ArrayList<CNum> in;

CNum[] input, dft;
void setup() {
  size(600, 600);
  frameRate(60);
  noFill();
  ellipseMode(RADIUS);
  
  in = new ArrayList();
  
  CNum tot = CiSMath.fromCart(0, 0);
  for(int i = 0; i < 20; i++) {
    double th = random(0, TAU), am = 10;
    in.add(tot.clone());
    tot.add(CiSMath.fromCart(am*Math.cos(th), am*Math.sin(th)));
  }
  
  dft = CiSMath.DFT(in.toArray(new CNum[in.size()]));
  quicksort(dft, 0, dft.length-1);
}

double t = 0;
void draw() {
  background(60); 
  translate(width/2, height/2);
  
  for(var e : in) {
    double[] inf = e.get();
    strokeWeight(2);
    point((float)inf[0], (float)inf[1]);
  }
  
  int N = dft.length-1;
  CNum tot = CiSMath.fromCart(0, 0);
  for(int n = -N; n <= N; n++) {
    CNum c_n = n < 0 ? dft[-n] : dft[n];
    double bef[] = tot.get(), aft[];
    
    tot.add(CiSMath.mult(c_n, CiSMath.fromPolar(TAU*n*t/N, 1)));
    aft = tot.get();
    
    strokeWeight(1);
    circle((float)bef[0], (float)bef[1], (float)c_n.get()[3]);
  }
  
  t += N/TAU*S;
}

void quicksort(CNum[] arr, int low, int high) {
  if (low < high) {
    CNum p = arr[high];
    int ind, i = low-1;

    for (int j = low; j < high; j++)
      if (arr[j].get()[3] > p.get()[3]) {
        i++;
        swap(arr, i, j);
      }
    swap(arr, i+1, high);
    ind = i+1;

    quicksort(arr, low, ind-1);
    quicksort(arr, ind+1, high);
  }
}
void swap(CNum[] arr, int a, int b) {
  CNum tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}
