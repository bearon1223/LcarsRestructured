class Warpcore extends Readout {
  Timer t1;
  Warpcore(float x, float y, float w, float h) {
    super(x, y, w, h);
    t1 = new Timer(12);
    //t2 = new Timer(12);
  }

  Warpcore(float x, float y) {
    this(x, y, 150, 340);
  }

  @Override
    void update() {
    super.update();
  }

  @Override
    void render() {
    update();
    //12 segmants
    fill(255);
    drawRect(0, 110, w, h-120*2+20, 50);
    fill(100);
    drawEllipse(originalSize.x/2, originalSize.y/2, 50, 50);
    //int segmantLight1 = (int)t1.getTime(false);
    //int segmantLight2 = (int)t1.getTime(true);
    int segmantLight1 = second()%6;
    int segmantLight2 = 12-segmantLight1;
    for (int i = 0; i < 6; i++) {
      if (segmantLight1 == i || segmantLight2 == i) fill(#95D2FF);
      else fill(#0075CB);
      drawRect(10, 20*i, w-20, 20, 50);
    }
    for (int i = 0; i < 6; i++) {
      if (segmantLight1 == i+7 || segmantLight2 == i+7) fill(#95D2FF);
      else fill(#0075CB);
      drawRect(10, 20*i+(h-120), w-20, 20, 50);
    }
    if (t1.countTimer()) t1.resetTimer();
    //if (t2.countTimer()) t2.resetTimer();
  }
}
