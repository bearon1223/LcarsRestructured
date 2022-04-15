class MainReadout extends Readout {
  Panel mainSystemsPanel;
  Panel navSystemsPanel;
  Panel navCenterPanel;
  Panel navTopPanel;
  Panel navBottomPanel;

  PVector targetingPointLoc;
  boolean setuptD = false;

  boolean isSector = false;

  MainReadout(float x, float y, float w, float h) {
    super(x, y, w, h);
    mainSystemsPanel = new Panel(this, 0, 0, w, h).panelCount(6, 5);
    navSystemsPanel = new Panel(this, 340, 150, 150, 150).panelCount(3, 6).setTextSize(5).setRounded();
    navCenterPanel = new Panel(this, 243, 120, 95, 211).panelCount(1, 4).addNames(navCenterPanelNames);
    navTopPanel = new Panel(this, 120, 0, w-125, 120).panelCount(6, 1).addNames(navTopPanelNames);
    navBottomPanel = new Panel(this, 0, 330, w, h-325).panelCount(7, 1).addNames(navBottomPanelNames);
  }

  void target(float x, float y, float size) {
    stroke(#FFAD29);
    strokeWeight(3);
    drawLine(x-size, y, x+size, y);
    drawLine(x, y-size, x, y+size);
    strokeWeight(1);
    stroke(255);
  }

  void systemMap(float x, float y) {
    float h = 173;
    x += 10;
    fill(255, 255, 0);
    mapArc(x, y+h/2, 50, 50, -HALF_PI, HALF_PI);
    noFill();
    stroke(255);
    mapArc(x, y+h/2, 80, 80, -HALF_PI, HALF_PI);
    mapArc(x, y+h/2, 160, 160, -HALF_PI, HALF_PI);
    mapArc(x, y+h/2, 260, 260, -QUARTER_PI*0.8, QUARTER_PI*0.8);
    mapArc(x, y+h/2, 180*2, 180*2, -QUARTER_PI/1.8, QUARTER_PI/1.8);
    fill(255);
    mapEllipse(x+40, y+h/2, 15, 15);
    mapEllipse(x+80, y+h/2, 27, 27);
    mapEllipse(x+130, y+h/2, 30, 30);
    mapEllipse(x+180, y+h/2, 20, 20);
  }

  void sectorMap(float x, float y) {
    int amount = 5;
    int index = 0;
    for (int i = 0; i <= amount; i++) {
      for (int j = 0; j < amount; j++) {
        stroke(150);
        PVector offset = new PVector(map(40, 0, 1000, 0, width), map(40, 0, 600, 0, height));
        if (i == amount) line(x+i*offset.x, y+j*offset.y, x+(i+0.3)*offset.x, y+j*offset.y);
        else if (j != 0) line(x+i*offset.x, y+j*offset.y, x+(i+1)*offset.x, y+j*offset.y);
        if (j == amount-1) line(x+i*offset.x, y+j*offset.y, x+i*offset.x, y+(j+0.2)*offset.y);
        else line(x+i*offset.x, y+j*offset.y, x+i*offset.x, y+(j+1)*offset.y);
        textAlign(RIGHT, BOTTOM);
        fill(255);
        textSize(7);
        if (i != amount && j != amount -1) text(generateRandomName(index*1972394), x + i*offset.x, y+j*offset.y, offset.x, offset.y);
        index++;
      }
    }
  }

  void navigationalScreen(float xo, float yo) {
    PVector imageSize = new PVector(228, 173);
    float x = this.x+map(xo, 0, 1000, 0, width);
    float y = this.y+map(yo, 0, 600, 0, height);
    if (!setuptD) targetingPointLoc = new PVector(xo+imageSize.x/2, yo+imageSize.y/2);
    setuptD = true;
    if (isSector) sectorMap(x, y);
    else systemMap(originalCoords.x+xo, originalCoords.y+yo);
    target(targetingPointLoc.x, targetingPointLoc.y, 5);
    noStroke();
    fill(0);
    drawRect(xo-2, yo-2, 12, 175);
    drawRect(xo+218, yo, 10, 173);
    displayImage(tacticalSurrounds, xo, yo, 228, 173);
  }

  void changePointPos(PVector direction) {
    if (within(new PVector(targetingPointLoc.x + direction.x, targetingPointLoc.y + direction.y), 15, 155, 218, 163)) {
      targetingPointLoc.x += direction.x;
      targetingPointLoc.y += direction.y;
    }
  }

  @Override
    void render() {
    update();
    switch(scene) {
    case 0:
      displayImage(standbyScreen, 0, 10);
      break;
    case 1:
      // System Directory
      mainSystemsPanel.render();
      mainSystemsPanel.getSinglePanel(5, 0).rename("Naviagation");
      mainSystemsPanel.getSinglePanel(5, 1).rename("Tactical");

      if (mainSystemsPanel.getSinglePanel(5, 1).clicked()) {
        sceneMain = 2;
        aReadout.scene = 1;
      }
      mainSystemsPanel.getSinglePanel(5, 0).clicked(() -> scene = 11);

      break;
    case 11:
      //Navigational Panel
      navSystemsPanel.render();
      navCenterPanel.render();
      navTopPanel.render();
      navBottomPanel.render();

      int increment = 5;
      circleButton(10, 10, 100, 100, null, null, null, null, () -> changePointPos(new PVector(0, -increment)), () -> changePointPos(new PVector(0, increment)), () -> changePointPos(new PVector(-increment, 0)), () -> changePointPos(new PVector(increment, 0)));
      circleButton(890 - originalCoords.x, 400 - originalCoords.y, 100, 100, null, null, null, null, null, null, null, null);
      navigationalScreen(10, 150);

      if (navTopPanel.getSinglePanel(0, 0).clicked() && isSector == false) {
        isSector = true;
        setuptD = false;
      }
      if (navTopPanel.getSinglePanel(1, 0).clicked() && isSector == true) {
        isSector = false;
        setuptD = false;
      }
      break;
    default:
      textAlign(CENTER, CENTER);
      fill(#D8A600);
      displayText("LCARS was unable to find requested information\nPanel Number: "+scene, w/2, h/2);
    }
  }
}
