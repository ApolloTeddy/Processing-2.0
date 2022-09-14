import CiSlib.*;


CNum a, b;
void setup() {
  size(200, 200);
  frameRate(4);
  a = CiSMath.fromCart(width/4, 0);
  b = CiSMath.rootOfUnity(4);
}

void draw() {
  background(120);
  translate(width/2, height/2);
  
  float[] aI = a.get();
  line(0, 0, aI[0], aI[1]);
  
  a.mult(b);
}

void mousePressed() {
  a.setC(mouseX - width/2, mouseY - height/2);
}
