import CiSlib.*;

Cam cam;

PImage ima;

CiSMath grouper;

ArrayList<CNum[]> groups;
void setup() {
  size(600, 600);
  colorMode(HSB, 100, 100, 100);
  cam = new Cam();
  grouper = new CiSMath();
  ima = loadImage("testB.png");
  ima.loadPixels();
  
  Tree tree = new Tree(new double[]{ima.width/2, ima.height/2, ima.height > ima.width ? ima.height/2 : ima.width/2}, 10);
  //ArrayList<CNum> locations = new ArrayList<CNum>();
  for(int n = 0; n < ima.pixels.length; n++) {
      double x = n%ima.width;
      if(ima.pixels[n] == color(0)) //locations.add(CiSMath.fromCart(x, (n - x)/ima.width));
        tree.insert(CiSMath.fromCart(x, (n - x)/ima.width));
  }
    println(tree.all().length);
    groups = grouper.makeGroups(tree, 10000);
    println(groups.size());
}

void draw() {
  background(60);
  cam.update();
  
  double[]camInf = cam.pos.get(), camInf2 = cam.anchor.get();
  translate((float)(camInf[0]+camInf2[0]), (float)(camInf[1]+camInf2[1]));
  scale((float)cam.loZoom);
  for(int i = 0; i < groups.size(); i++) {
    var curgroup = groups.get(i);
    for(int j = 0; j < curgroup.length; j++) {
      double[] inf = curgroup[j].get();
      
      strokeWeight(2);
      stroke(0, 0, map(j, 0, curgroup.length, 0, 100));
      point((float)inf[0], (float)inf[1]);
    }
  }
}

void mouseDragged() {
  if(mouseButton == LEFT) cam.acc.add(CiSMath.fromCart( (mouseX-pmouseX)*0.2717, (mouseY-pmouseY)*0.2717) );
}

void mouseWheel(MouseEvent e) {
  cam.loZoom = e.getCount() > 0 ? cam.loZoom - 0.5 : cam.loZoom + 0.5;
}
