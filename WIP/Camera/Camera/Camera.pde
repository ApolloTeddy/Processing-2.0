Cam cam;

void setup() {
  size(400, 400);
  cam = new Cam();
  cam.fixate(CiSMath.fromCart(0, 100));
  
  strokeWeight(3);
}

void mouseDragged() {
  cam.acc.add(CiSMath.fromCart( (mouseX-pmouseX)*0.2717, (mouseY-pmouseY)*0.2717) );
}

void mouseWheel(MouseEvent e) {
  cam.loZoom = e.getCount() > 0 ? cam.loZoom - 0.15 : cam.loZoom + 0.15;
}

void draw() {
  background(60);
  cam.update();
  
  double[]camInf = cam.pos.get(), camInf2 = cam.anchor.get();
  translate((float)(camInf[0]+camInf2[0]), (float)(camInf[1]+camInf2[1]));
  scale((float)cam.loZoom);
  
  circle(0, 100, 100);
}
