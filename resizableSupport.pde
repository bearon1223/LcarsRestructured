void mapRect(float x, float y, float w, float h) {
  rect(ezMap(x, true), ezMap(y, false), ezMap(w, true), ezMap(h, false));
}

void mapRect(float x, float y, float w, float h, float r) {
  rect(ezMap(x, true), ezMap(y, false), ezMap(w, true), ezMap(h, false), r);
}

void mapImage(PImage image, float x, float y, float w, float h) {
  image(image, map(x, 0, 1000, 0, width), map(y, 0, 600, 0, height), map(w, 0, 1000, 0, width), map(h, 0, 600, 0, height));
}

void mapImagenoW(PImage image, float x, float y, float w, float h) {
  image(image, map(x, 0, 1000, 0, width), map(y, 0, 600, 0, height), w, h);
}

void mapEllipse(float x, float y, float r1, float r2) {
  ellipse(ezMap(x, true), ezMap(y, false), ezMap(r1, true), ezMap(r2, false));
}

void mapArc(float x, float y, float r1, float r2, float start, float stop) {
  arc(ezMap(x, true), ezMap(y, false), ezMap(r1, true), ezMap(r2, false), start, stop);
}

void mapLine(float x1, float y1, float x2, float y2) {
  line(ezMap(x1, true), ezMap(y1, false), ezMap(x2, true), ezMap(y2, false));
}

float ezMap(float x, boolean isWidth) {
  if (isWidth) return map(x, 0, 1000, 0, width);
  else return map(x, 0, 600, 0, height);
}

boolean within(PVector vector, float x, float y, float w, float h) {
  if (vector.x > x && vector.y > y && vector.x < x + w && vector.y < y+h) return true;
  return false;
}

boolean within(Readout r, PVector vector, float x, float y, float w, float h) {
  if (vector.x+r.x > x && vector.y+r.y > y && vector.x+r.x < x + w && vector.y+r.y < y+h) return true;
  return false;
}

float hypotenuse(float x, float y) {
  return sqrt(x*x + y*y);
}

boolean within(Readout r, PVector vector, float x, float y, float d) {
  if (abs(hypotenuse(r.x+vector.x-x, r.y+vector.y-y)) <= d/2) return true;
  return false;
}

void button(float x, float y, float w, float h, Runnable run) {
  if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h && mousePressed && mousePressed != pMousePressed) {
    run.run();
  }
}

class Timer {
  int time = 0, startingTime;
  Timer(int time) {
    startingTime = time;
  }
  
  void resetTime(int time){
    this.time = 0;
    startingTime = time;
  }
  
  void resetTimer(){
    time = 0;
  }
  
  float getTime(boolean countDown) {
    if (countDown) return round(startingTime - time/frameRate);
    return floor(time/frameRate);
  }
  
  boolean countTimer(){
    time++;
    return floor(time/frameRate) >= startingTime+1;
  }
}
