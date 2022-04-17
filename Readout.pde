public class Readout {
  float x, y, w, h;
  PVector originalCoords, originalSize;
  int scene = 0;
  RandomColorRect[] r = new RandomColorRect[10];
  private Timer t = new Timer(2);
  private String[] s = new String[3];

  public Readout(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    originalCoords = new PVector(this.x, this.y);
    originalSize = new PVector(this.w, this.h);

    resetDefaultReadout();
    scene = 0;
  }

  void circleButton(float x, float y, float w, float h, Runnable run1, Runnable run2, Runnable run3, Runnable run4, Runnable run5, Runnable run6, Runnable run7, Runnable run8) {
    displayImage(circleButton, x, y, w, h);
    /*
     *  Runnable Legend
     *  11 5 22
     *  11 5 22
     *  77 - 88
     *  33 6 44
     *  33 6 44
     */
    fill(255);
    if (button(x, y, w*0.40, h*0.40) && run1 != null)               run1.run();
    if (button(x+w*0.60, y, w*0.40, h*0.40) && run2 != null)        run2.run();
    if (button(x, y+h*0.60, w*0.40, h*0.40) && run3 != null)        run3.run();
    if (button(x+w*0.60, y+h*0.60, w*0.40, h*0.40) && run4 != null) run4.run();
    if (button(x+w*0.43, y, w*0.14, h*0.40) && run5 != null)        run5.run();
    if (button(x+w*0.43, y+h*0.60, w*0.14, h*0.40) && run6 != null) run6.run();
    if (button(x, y+h*0.43, w*0.40, h*0.14) && run7 != null)        run7.run();
    if (button(x+w*0.60, y+h*0.43, w*0.40, h*0.14) && run8 != null) run8.run();
  }

  private void generateStrings() {
    for (int i = 0; i < s.length; i++) {
      String[] number = new String[36];
      for(int j = 0; j < 36; j++){
        if(j != 6 && j != 24){
          number[j] = str(round(random(1, 9)));
        } else {
          number[j] = "-";
        }
      }
      String output = String.join("", number);
      s[i] = output;
    }
  }

  private void resetDefaultReadout() {
    generateStrings();
    t.resetTimer();
  }

  Readout setStartingScene(int scene) {
    this.scene = scene;
    return this;
  }

  void displayText(String text, float x, float y, float w, float h) {
    text(text, ezMap(originalCoords.x+x, true), ezMap(originalCoords.y+y, false), ezMap(w, true), ezMap(h, false));
  }

  void displayText(String text, float x, float y) {
    text(text, ezMap(originalCoords.x+x, true), ezMap(originalCoords.y+y, false));
  }

  void displayImage(PImage image, float x, float y, float w, float h) {
    image(image, this.x+map(x, 0, 1000, 0, width), this.y+map(y, 0, 600, 0, height), map(w, 0, 1000, 0, width), map(h, 0, 600, 0, height));
  }

  void displayImage(PImage image, float x, float y) {
    mapImagenoW(image, originalCoords.x+x, originalCoords.y+y, w, h);
  }

  void drawRect(float x, float y, float w, float h) {
    mapRect(originalCoords.x+x, originalCoords.y+y, w, h);
  }

  void drawRect(float x, float y, float w, float h, float r) {
    mapRect(originalCoords.x+x, originalCoords.y+y, w, h, r);
  }

  void drawEllipse(float x, float y, float r1, float r2) {
    mapEllipse(originalCoords.x + x, originalCoords.y + y, r1, r2);
  }

  void drawRect(float x, float y) {
    mapRect(this.x + x, this.y+y, w - x, h - y);
  }

  void drawLine(float x1, float y1, float x2, float y2) {
    mapLine(originalCoords.x+x1, originalCoords.y+y1, originalCoords.x+x2, originalCoords.y+y2);
  }

  boolean button(float x, float y, float w, float h) {
    x = this.x+map(x, 0, 1000, 0, width);
    y = this.y+map(y, 0, 600, 0, height);
    w = ezMap(w, true);
    h = ezMap(h, true);

    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      isOver = true;
      if (mousePressed && mousePressed != pMousePressed) {
        click.play();
        return true;
      }
    }
    return false;
  }

  void update() {
    x = map (originalCoords.x, 0, 1000, 0, width);
    y = map (originalCoords.y, 0, 600, 0, height);

    w = map (originalSize.x, 0, 1000, 0, width);
    h = map (originalSize.y, 0, 600, 0, height);
  }

  void render() {
    textAlign(LEFT, TOP);
    textSize(map(originalSize.x/originalSize.y*12, 0, hypotenuse(1000, 600), 0, hypotenuse(width, height)));
    fill(255);
    if (t.countTimer()) resetDefaultReadout();
    for (int i = 0; i < s.length; i++) {
      float offset = (2.5*originalSize.x/originalSize.y*12);
      if (floor(t.getTime(false)) == i) fill(255, 124, 16);
      else fill(#6A58FF);
      displayText(s[i], 0, i*offset, originalSize.x, originalSize.y-i*offset);
    }
    update();
  }
}
