import CiSlib.*;

CNum[] input, dft;
void setup() {
  size(600, 600);
  frameRate(60);
  ArrayList<CNum> in = new ArrayList();
  for(int w = -width/4; w < width/4; w++) {
    in.add(CiSMath.fromCart(w, 0));
  }
  dft = CiSMath.DFT(in.toArray(new CNum[in.size()]));
}

double t = 0;
void draw() {
  int N = dft.length/2;
  CNum tot = CiSMath.fromCart(0, 0);
  for(int n = -N; n < N; n++) {
    double u = (TAU*n*t)/(dft.length);
    tot.add(CiSMath.mult(dft[n+N], CiSMath.fromPolar(u, 1)));
  }
  stroke(10);
  double[] info = tot.get();
  point((float)info[0], (float)info[1]);
  t += dft.length/60;
}
