import CiSlib.*;


CNum a, b;
void setup() {
  size(400, 400);
  frameRate(144);
  a = CiSMath.fromCart(width/4, 0);
  b = CiSMath.rootOfUnity(144);
}

void draw() {
  background(120);
  translate(width/2, height/2);
  
  double[] aI = a.get();
  line(0, 0, (float)aI[0], (float)aI[1]);
  
  a.mult(b);
}

void mousePressed() {
  a.setC(mouseX - width/2, mouseY - height/2);
}
