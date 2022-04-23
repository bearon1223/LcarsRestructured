class Panel {
  protected float x, y;
  private PVector originalCoords;
  private PVector originalSize;
  protected PVector size;
  private String[][] names = new String[4][1];
  private PVector numberOfPanels = new PVector(3, 0);
  private int roundedSides = 0;
  private boolean lastReversed = false;
  private float textSize = 12;
  private float offset = 5;

  RandomColorRect[][] r = new RandomColorRect[(int)numberOfPanels.x][(int)numberOfPanels.y];
  Panel(float x, float y, PVector size) {
    this.x = x;
    this.y = y;
    originalCoords = new PVector(x, y);
    this.size = new PVector(size.x, size.y);
    originalSize = new PVector(size.x, size.y);
    for (int i = 0; i < numberOfPanels.x; i++) {
      for (int j = 0; j < numberOfPanels.y; j++) {
        r[i][j] = new RandomColorRect();
      }
    }
  }

  Panel(float x, float y, float sizex, float sizey) {
    this(x, y, new PVector(sizex, sizey));
  }

  Panel(Readout r, float x, float y, float sizex, float sizey) {
    this(r.x+x, r.y+y, sizex, sizey);
  }

  Panel lastReversed() {
    lastReversed = true;
    return this;
  }

  Panel panelCount(PVector numberOfPanels) {
    this.numberOfPanels = numberOfPanels;
    if (numberOfPanels.x < 1) numberOfPanels.x = 1;
    if (numberOfPanels.y < 1) numberOfPanels.y = 1;
    r = new RandomColorRect[(int)numberOfPanels.x][(int)numberOfPanels.y];
    names = new String[(int)numberOfPanels.y+1][(int)numberOfPanels.x+1];
    for (int i = 0; i < numberOfPanels.x; i++) {
      for (int j = 0; j < numberOfPanels.y; j++) {
        r[i][j] = new RandomColorRect(generateRandomName());
      }
    }
    return this;
  }

  Panel setRounded() {
    roundedSides = 2;
    return this;
  }

  Panel setOneSideRounded() {
    roundedSides = 1;
    return this;
  }

  Panel panelCount(int x, int y) {
    this.numberOfPanels = new PVector(x, y);
    if (x < 1) numberOfPanels.x = 1;
    if (y < 1) numberOfPanels.y = 1;
    r = new RandomColorRect[(int)numberOfPanels.x][(int)numberOfPanels.y];
    names = new String[(int)numberOfPanels.y+1][(int)numberOfPanels.x+1];
    for (int i = 0; i < numberOfPanels.x; i++) {
      for (int j = 0; j < numberOfPanels.y; j++) {
        r[i][j] = new RandomColorRect(generateRandomName());
      }
    }
    return this;
  }

  Panel changeOffset (float offset) {
    this.offset = offset;
    return this;
  }

  Panel setTextSize(float textSize) {
    this.textSize = textSize;
    return this;
  }

  Panel addNames(String[][] s) {
    names = s;
    return this;
  }

  RandomColorRect[][] getPanels() {
    return r;
  }

  RandomColorRect getSinglePanel(int x, int y) {
    return r[x][y];
  }

  void executeCode(Runnable toRun) {
    toRun.run();
  }

  void update() {
    x = map (originalCoords.x, 0, 1000, 0, width);
    y = map (originalCoords.y, 0, 600, 0, height);

    size.x = map (originalSize.x, 0, 1000, 0, width);
    size.y = map (originalSize.y, 0, 600, 0, height);
  }

  void clickArray(Readout readout, int[][] a) {
    for (int i = 0; i < numberOfPanels.x; i++) {
      for (int j = 0; j < numberOfPanels.y; j++) {
        if (r[i][j].clicked()) {
          readout.scene = a[j][i];
        }
      }
    }
  }

  void render() {
    PVector rectSize = new PVector((size.x) / numberOfPanels.x, (size.y) / numberOfPanels.y);
    for (int i = 0; i < numberOfPanels.x; i++) {
      for (int j = 0; j < numberOfPanels.y; j++) {
        r[i][j].resetPosition((float)x + i * rectSize.x, (float)y + j * rectSize.y, rectSize.x-offset, rectSize.y-offset);
        if (roundedSides == 0) r[i][j].render(0);
        if (roundedSides == 2) r[i][j].render(2);

        if (!lastReversed) {
          if (roundedSides == 1) r[i][j].render(1);
        } else {
          if (roundedSides == 1 && i == numberOfPanels.x - 1) r[i][j].render(1, true);
          if (roundedSides == 1 && i < numberOfPanels.x - 1) r[i][j].render(1, false);
        }
        r[i][j].textSize = textSize;
        if (names[j][i] == null) r[i][j].displayText();
        else r[i][j].displayText(names[j][i]);
      }
    }
    update();
  }
}


class RandomColorRect {
  int[] randColor = new int[3];
  float x, y, w, h;
  boolean isReversed = false;
  float textSize = 12;
  String text = "";

  RandomColorRect(String name) {
    randColor[0] = 50;
    randColor[1] = (int)random(100, 200);
    randColor[2] = (int)random(200, 255);
    text = name;
  }

  RandomColorRect() {
    this(generateRandomName());
  }

  float hypotenuse(float x, float y) {
    return sqrt(x*x + y*y);
  }

  void resetPosition(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void displayText() {
    if (isReversed) textAlign(LEFT, BOTTOM);
    if (!isReversed) textAlign(RIGHT, BOTTOM);
    fill(0);
    textSize(map(textSize, 0, hypotenuse(1000, 600), 0, hypotenuse(width, height)));
    text(text, (float)x + w/12, (float)y - h/8, w- w/8 - w/12, h);
  }

  void displayText(String text) {
    if (isReversed) textAlign(LEFT, BOTTOM);
    if (!isReversed) textAlign(RIGHT, BOTTOM);
    fill(0);
    textSize(map(textSize, 0, hypotenuse(1000, 600), 0, hypotenuse(width, height)));
    text(text, (float)x + w/12, (float)y - h/8, w- w/8 - w/12, h);
  }

  boolean clicked() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      isOver = true;
      if (mousePressed && mousePressed != pMousePressed) {
        click.play();
        fill(0, 50);
        rect(x, y, w, h);
        return true;
      }
    }
    return false;
  }

  boolean clicked(boolean passCondition) {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      isOver = true;
      if (mousePressed && mousePressed != pMousePressed) {
        if (passCondition) click.play();
        else failClick.play();
        fill(0, 50);
        rect(x, y, w, h);
        return passCondition;
      }
    }
    return false;
  }

  void clicked(Runnable run) {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      isOver = true;
      if (mousePressed && mousePressed != pMousePressed) {
        click.play();
        fill(0, 50);
        rect(x, y, w, h);
        run.run();
      }
    }
  }

  void rename(String text) {
    this.text = text;
  }

  void render(int round) {
    noStroke();
    fill(randColor[0], randColor[1], randColor[2]);
    if (round == 0) rect(x, y, w, h, 1);
    if (round == 1) {
      rect(x + w/4, y, w - w/4, h, 2);
      ellipse(x+w/4, y+h/2, w - w/2, h);
    }
    if (round == 2) rect(x, y, w, h, 45);
  }

  void render(int round, boolean isReversed) {
    this.isReversed = isReversed;
    noStroke();
    fill(randColor[0], randColor[1], randColor[2]);
    if (round == 0) rect(x, y, w, h, 2);
    if (round == 1 && !isReversed) {
      rect(x + w/4, y, w - w/4, h, 2);
      ellipse(x+w/4, y+h/2, w - w/2, h);
    } else if (round == 1 && isReversed) {
      rect(x, y, w - w/4, h, 2);
      ellipse(w + x - w / 4, y + h / 2, w - w / 2, h);
    }
    if (round == 2) rect(x, y, w, h, 45);
  }
}
