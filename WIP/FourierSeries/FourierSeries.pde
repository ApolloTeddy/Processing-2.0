import CiSlib.*;

Cam cam;

double Sp = 1; // Speed constant

ArrayList<CNum[]> in;
boolean follow = true;
CNum[] input, dft;
PImage ima;

CiSMath grouper;

void setup() {
  size(900, 900);
  cam = new Cam();
  grouper = new CiSMath();
  ima = loadImage("testB.png");
  ima.loadPixels();
  
  //frameRate(60);
  noFill();
  ellipseMode(RADIUS);
  colorMode(HSB, 100, 100, 100);
  
  Tree tree = new Tree(new double[]{ima.width/2, ima.height/2, ima.height > ima.width ? ima.height/2 : ima.width/2}, 10);
  //ArrayList<CNum> locations = new ArrayList<CNum>();
  for(int n = 0; n < ima.pixels.length; n++) {
      double x = n%ima.width;
      if(ima.pixels[n] == color(0)) //locations.add(CiSMath.fromCart(x, (n - x)/ima.width));
        tree.insert(CiSMath.fromCart(x, (n - x)/ima.width));
  }
  
  in = grouper.makeGroups(tree);
  
  /*
  CNum tot = CiSMath.fromCart(0, 0);
  double th = random(0, TAU), tol = TAU/38  , am = 0.025;
  for(int i = 0; i < 6000; i++) {
    in.add(tot.clone());
    tot.add(CiSMath.fromCart(am*Math.cos(th), am*Math.sin(th)));
    
    th += random((float)-tol, (float)tol);
  }*/
  
  dft = CiSMath.FSCDFT(in.toArray(new CNum[CiSMath.len(in)]));
  quicksort(dft, 0, dft.length-1);
}

void mouseDragged() {
  cam.acc.add(CiSMath.fromCart( (mouseX-pmouseX)*0.2717, (mouseY-pmouseY)*0.2717) );
}

void mouseWheel(MouseEvent e) {
  cam.loZoom = e.getCount() > 0 ? cam.loZoom - 0.5 : cam.loZoom + 0.5;
  println(cam.loZoom);
}

void mousePressed() {
  if(mouseButton == CENTER) {
    if(!follow) cam.pos.setP(0, 0);    
    follow = !follow;
  }
}

void keyPressed() {
  if(key == 'z' || key == 'Z') {
    cam.loZoom = 75;
  } else if(key == 'x' || key == 'X') {
    cam.loZoom = 1;
  } else if(key == 'e' || key == 'E') {
    t = (in.size() - 250)*TAU/in.size();
  } else if(key == 'b' || key == 'B') {
    t = 0;
  }
}

double t = 0;
void draw() {
  background(20);
  cam.update();
  double[]camInf = cam.pos.get(), camInf2 = cam.anchor.get();
  translate((float)(camInf[0]+camInf2[0]), (float)(camInf[1]+camInf2[1]));
  scale((float)cam.loZoom);
  
  for(int i = 0; i < in.size(); i++) {
    double[] inf = in.get(i).get();
    strokeWeight(0.2);
    stroke(map(i, 0, in.size(), 0, 100), 100, 100);
    point((float)inf[0], (float)inf[1]);
  }
  
  int N = dft.length;
  CNum tot = CiSMath.fromCart(0, 0);
  for(int n = 0; n < N; n++) {
    double bef[] = tot.get(), aft[], inf[] = dft[n].get(), th = inf[2]+inf[4]*t;
    
    tot.add(CiSMath.fromCart(inf[3]*Math.cos(th), inf[3]*Math.sin(th)));
    aft = tot.get();
    
    strokeWeight(0.05);
    stroke(25);
    if(inf[3] > 1) circle((float)bef[0], (float)bef[1], (float)inf[3]);
    strokeWeight(0.05);
    stroke(40);
    line((float)bef[0], (float)bef[1], (float)aft[0], (float)aft[1]);
    //point((float)aft[0], (float)aft[1]);
  }
  if(follow) cam.fixate(tot);
  
  double[] tmpInf = tot.get();
  strokeWeight(0.1);
  stroke(0, 0, 100);
  point((float)tmpInf[0], (float)tmpInf[1]);
  //t = (t + N/TAU*S)%N;
  if(frameCount%Sp == 0) t = (t + TAU/N)%TAU;
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

class Cam {
  CNum pos, vel, acc, anchor;
  double maxspeed = 5, loZoom = 50;
  Cam() {
    this.pos = CiSMath.fromPolar(0, 0);
    this.vel = CiSMath.fromPolar(0, 0);
    this.acc = CiSMath.fromPolar(0, 0);
    this.anchor = CiSMath.fromPolar(0, 0);
  }
  
  void fixate(CNum pos) { // D = T - P : S = D - V
    CNum t = pos.clone();
    t.sub(CiSMath.fromCart(width/(2*loZoom), height/(2*loZoom)));
    this.anchor = CiSMath.mult(t, -loZoom);
  }
  
  void update() {
    this.vel.add(this.acc);
    this.vel.limitMag(this.maxspeed);
    this.pos.add(this.vel);
    
    this.acc.setP(0, 0);
    this.vel.mult(0.75);
    this.loZoom = loZoom >= 75 ? 75 : loZoom;
    this.loZoom = loZoom <= 3.25 ? 3.25 : loZoom;
  } 
}
