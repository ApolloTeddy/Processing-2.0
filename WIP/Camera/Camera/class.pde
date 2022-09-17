import CiSlib.*;

class Cam {
  CNum pos, vel, acc;
  double maxspeed = 5, loZoom = 1;
  Cam() {
    this.pos = CiSMath.fromPolar(0, 0);
    this.vel = CiSMath.fromPolar(0, 0);
    this.acc = CiSMath.fromPolar(0, 0);
  }
  
  void follow(CNum pos) { // D = T - P : S = D - V
    CNum Ste = CiSMath.sub(pos, this.pos).limitMag(10);
    Ste.sub(this.vel);
    cam.acc.add(Ste);
  }
  
  void update() {
    this.vel.add(this.acc);
    this.vel.limitMag(this.maxspeed);
    this.pos.add(this.vel);
    
    this.acc.setP(0, 0);
    this.vel.mult(0.75);
    this.loZoom = loZoom > 10 ? 10 : loZoom;
    this.loZoom = loZoom < 0.01 ? 0.01 : loZoom;
  } 
}
