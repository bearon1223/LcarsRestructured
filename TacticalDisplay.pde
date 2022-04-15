class TacScreen extends Readout {
  Panel mainPanelL;
  Panel mainPanelR;
  Panel topPanel;

  TacScreen() {
    super(170+220, 0, 1000-(170+220), 600);
    mainPanelL = new Panel(this, 5, 150, 70, h-150).panelCount(1, 12);
    mainPanelR = new Panel(this, 105, 150, 70, h-150).panelCount(1, 12).setOneSideRounded().lastReversed();
    topPanel = new Panel(this, 5, 5, w-10, 145).panelCount(5, 1);
  }

  void tacticalScreen(float xo, float yo) {
    int amount = 5;
    int index = 0;
    //PVector imageSize = new PVector(228, 173);
    float x = this.x+map(xo, 0, 1000, 0, width);
    float y = this.y+map(yo, 0, 600, 0, height);
    //if (!setuptD) targetingPointLoc = new PVector(xo+imageSize.x/2, yo+imageSize.y/2);
    //setuptD = true;
      for (int i = 0; i <= amount; i++) {
        for (int j = 0; j < amount; j++) {
          stroke(150);
          PVector offset = new PVector(map(40, 0, 1000, 0, width), map(40, 0, 600, 0, height));
          if (i == amount) line(x+i*offset.x, y+j*offset.y, x+(i+0.3)*offset.x, y+j*offset.y);
          else line(x+i*offset.x, y+j*offset.y, x+(i+1)*offset.x, y+j*offset.y);
          if (j == amount-1) line(x+i*offset.x, y+j*offset.y, x+i*offset.x, y+(j+0.2)*offset.y);
          else line(x+i*offset.x, y+j*offset.y, x+i*offset.x, y+(j+1)*offset.y);
          textAlign(RIGHT, BOTTOM);
          fill(255);
          textSize(7);
          if (i != amount && j != amount -1) text(generateRandomName(index*1972394), x + i*offset.x, y+j*offset.y, offset.x, offset.y);
          index++;
        }
    }
    //target(targetingPointLoc.x, targetingPointLoc.y, 5);
    noStroke();
    fill(0);
    drawRect(xo-2, yo-2, 12, 175);
    drawRect(xo+218, yo, 10, 173);
    displayImage(tacticalSurrounds, xo, yo, 228, 173);
  }

  @Override
    void render() {
    update();
    displayImage(navTemplate, 0, 0);
    mainPanelL.render();
    mainPanelR.render();
    topPanel.render();
    circleButton(325, 360, 150, 150, null, null, null, null, null, null, null, null);
  }
}
