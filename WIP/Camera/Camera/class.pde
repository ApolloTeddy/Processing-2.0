import CiSlib.*;

class Cam {
  CNum pos, vel, acc, anchor;
  double maxspeed = 5, loZoom = 1;
  Cam() {
    this.pos = CiSMath.fromPolar(0, 0);
    this.vel = CiSMath.fromPolar(0, 0);
    this.acc = CiSMath.fromPolar(0, 0);
    this.anchor = CiSMath.fromPolar(0, 0);
  }
  
  void fixate(CNum pos) { // D = T - P : S = D - V
    double zoomCoef = 1/(2*loZoom);
    CNum t = pos.clone();
    t.sub(CiSMath.fromCart(width*zoomCoef, height*zoomCoef));
    this.anchor = CiSMath.mult(t, -loZoom);
  }
  
  void update() {
    this.vel.add(this.acc);
    this.vel.limitMag(this.maxspeed);
    this.pos.add(this.vel);
    
    this.acc.setP(0, 0);
    this.vel.mult(0.75);
    this.loZoom = loZoom >= 3 ? 3 : loZoom;
    this.loZoom = loZoom <= 0.15 ? 0.15 : loZoom;
  } 
}
