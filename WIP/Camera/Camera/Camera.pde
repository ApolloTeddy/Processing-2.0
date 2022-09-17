Cam cam;

void setup() {
  size(400, 400);
  cam = new Cam();
  strokeWeight(3);
}

void mouseDragged() {
  if(mouseButton == LEFT) cam.acc.add(CiSMath.fromCart( (mouseX-pmouseX)*0.2717, (mouseY-pmouseY)*0.2717) );
}

void mouseWheel(MouseEvent e) {
  cam.loZoom = e.getCount() > 0 ? cam.loZoom - 0.5 : cam.loZoom + 0.5;
}

void keyPressed() {
  if(key == 'z' || key == 'Z') {
    cam.loZoom = 75;
  } else if(key == 'x' || key == 'X') {
    cam.loZoom = 1;
  }
}

void draw() {
  background(60);
  cam.update();
  double invZ = 1/cam.loZoom;
  cam.fixate(CiSMath.fromCart((mouseX - width/2)*invZ, (mouseY - height/2)*invZ)`);
  
  double[]camInf = cam.pos.get(), camInf2 = cam.anchor.get();
  translate((float)(camInf[0]+camInf2[0]), (float)(camInf[1]+camInf2[1]));
  scale((float)cam.loZoom);
  
  circle(0, 0, 100);
}
