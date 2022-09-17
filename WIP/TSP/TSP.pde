import CiSlib.*;

PImage ima;

CNum[] path;
void setup() {
  size(600, 600);
  ima = loadImage("testA.png");
  ima.loadPixels();
  
  ArrayList<CNum> locations = new ArrayList<CNum>();
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      if(ima.pixels[x + y*width] == color(0)) locations.add(CiSMath.fromCart(x, y));
    }
  }
  path = CiSMath.TSP(locations.toArray(new CNum[locations.size()]));
}
