import CiSlib.*;

double S = 0.01; // speed constant

CNum[] input, dft;
void setup() {
  size(600, 600);
  frameRate(60);
  noFill();
  ellipseMode(RADIUS);
  
  ArrayList<CNum> in = new ArrayList();
  
  in.add(CiSMath.fromCart(10, 0));
  in.add(CiSMath.fromCart(10 + 30*cos(10), 30*sin(10)));
  in.add(CiSMath.fromCart(10 + 30*cos(10) + 30*cos(50), 10*sin(10) + 10*sin(50)));
  dft = CiSMath.DFT(in.toArray(new CNum[in.size()]));
  quicksort(dft, 0, dft.length-1);
}

double t = 0;
void draw() {
  background(60);
  translate(width/2, height/2);
  
  int N = dft.length;
  CNum tot = CiSMath.fromCart(0, 0);
  for(int n = 0; n < N; n++) {
    CNum coef = dft[n];
    double info[] = coef.get(), dInf[] = tot.get(), pInf[], th = info[2] + info[4]*t;
    
    tot.add(CiSMath.fromCart(info[3]*Math.cos(th), info[3]*Math.sin(th)));
    pInf = tot.get();
    
    strokeWeight(1);
    circle((float)dInf[0], (float)dInf[1], (float)info[3]);
    line((float)dInf[0], (float)dInf[1], (float)pInf[0], (float)pInf[1]);
    strokeWeight(4);
    point((float)pInf[0], (float)pInf[1]);
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
