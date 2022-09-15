import CiSlib.*;

CNum x_n[];
void setup() {
  x_n = new CNum[]
  {
    CiSMath.fromCart(1, 0),
    CiSMath.fromCart(2, -1),
    CiSMath.fromCart(0, -1),
    CiSMath.fromCart(-1, 2)
  };
  
  CNum[] X = CiSMath.DFT(x_n);
  
  for(var x : X) {
    double[] info = x.get();
    println(info[0] + " + " + info[1] + "i");
  }
}
