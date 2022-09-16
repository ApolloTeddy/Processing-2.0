import CiSlib.*;

double S = 0.0005; // speed constant

ArrayList<CNum> in;

CNum[] input, dft;
void setup() {
  size(600, 600);
  frameRate(60);
  noFill();
  ellipseMode(RADIUS);
  colorMode(HSB, 100, 100, 100);
  
  in = new ArrayList();
  
  CNum tot = CiSMath.fromCart(random(width/6-50, width/6+50), 0);
  double th = random(0, TAU), tol = TAU/24  , am = 0.5;
  for(int i = 0; i < 5000; i++) {
    in.add(tot.clone());
    tot.add(CiSMath.fromCart(am*Math.cos(th), am*Math.sin(th)));
    
    th += random((float)-tol, (float)tol);
  }
  
  dft = CiSMath.FSCDFT(in.toArray(new CNum[in.size()]));
  quicksort(dft, 0, dft.length-1);
}

double t = 0;
void draw() {
  background(60); 
  translate(width/2, height/2);
  
  for(int i = 0; i < in.size(); i++) {
    double[] inf = in.get(i).get();
    strokeWeight(3);
    stroke(map(i, 0, in.size(), 0, 100), 100, 100);
    point((float)inf[0], (float)inf[1]);
  }
  
  int N = dft.length;
  CNum tot = CiSMath.fromCart(0, 0);
  for(int n = 0; n < N; n++) {
    double bef[] = tot.get(), aft[], inf[] = dft[n].get(), th = inf[2]+inf[4]*t;
    
    tot.add(CiSMath.fromCart(inf[3]*Math.cos(th), inf[3]*Math.sin(th)));
    aft = tot.get();
    
    strokeWeight(0.5);
    stroke(75);
    //circle((float)bef[0], (float)bef[1], (float)dft[n].get()[3]);
    strokeWeight(1);
    stroke(0);
    line((float)bef[0], (float)bef[1], (float)aft[0], (float)aft[1]);
    strokeWeight(2.25);
    point((float)aft[0], (float)aft[1]);
  }
  double[] tmpInf = tot.get();
  strokeWeight(3);
  stroke(0, 0, 100);
  point((float)tmpInf[0], (float)tmpInf[1]);
  
  //t = (t + N/TAU*S)%N;
  t = (t + TAU/N)%N;
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
