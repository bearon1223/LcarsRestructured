class TacticalDisplay extends Readout {
  Sector[][] s;
  final PVector imageSize = new PVector(228, 173);

  PVector targetingPointLoc;
  PVector selected = coordinates;
  PVector selectedSector = new PVector(0, 0);

  Boolean isClicked = false;

  TacticalDisplay(float x, float y) {
    super(x, y, 228, 173);
    s = new Sector[5][4];
    int index = 0;
    for (int j = 0; j < 4; j++) {
      for (int i = 0; i < 5; i++) {
        targetingPointLoc = new PVector(imageSize.x/2, imageSize.y/2);
        s[i][j] = new Sector(new PVector(x, y), index, randomSysCoords(7));
        index++;
      }
    }
  }

  void target(float x, float y, float size) {
    stroke(#FFAD29);
    strokeWeight(3);
    drawLine(x-size, y, x+size, y);
    drawLine(x, y-size, x, y+size);
    strokeWeight(1);
    stroke(255);
  }

  void systemMap() {
    float yCoord = originalCoords.y+originalSize.y/2;
    s[(int)selectedSector.x][(int)selectedSector.y].getSystem(floor(selected.y)).renderPlanets(yCoord);

    fill(255);
    textAlign(LEFT, TOP);
    textSize(13);
    displayText("Selected: Sector"+floor(selected.x+1)+", System "+floor(selected.y+1) + ", \nPlanet " + floor(selected.z), 10, 15);
    textAlign(RIGHT, BOTTOM);

    if (isClicked && within(this, targetingPointLoc, 410, yCoord, 50)) {
      selected.z = 0;
    } else  if (isClicked && within(this, targetingPointLoc, 450, yCoord, 15)) {
      selected.z = 1;
    } else if (isClicked && within(this, targetingPointLoc, 490, yCoord, 27)) {
      selected.z = 2;
    } else if (isClicked && within(this, targetingPointLoc, 540, yCoord, 30)) {
      selected.z = 3;
    } else if (isClicked && within(this, targetingPointLoc, 590, yCoord, 20)) {
      selected.z = 4;
    }
  }

  void systemSelect(PVector index) {
    textAlign(LEFT, TOP);
    displayText("Selected Sector: "+floor(selected.x+1)+", System: "+floor(selected.y+1), 10, 15);
    textAlign(RIGHT, BOTTOM);
    Sector sector = s[(int)index.x][(int)index.y];
    sector.renderSector();
    for (int i = 0; i < sector.systemAmount; i++) {
      if (isClicked && within(this, targetingPointLoc, sector.getSystem(i).loc.x, sector.getSystem(i).loc.y, sector.getSystem(i).r)) {
        selected.y = i;
      }
    }
  }

  void sectorMap() {
    int amount = 5;
    int index = 0;
    for (int i = 0; i <= amount; i++) {
      for (int j = 0; j < amount; j++) {
        stroke(150);
        PVector offset = new PVector(ezMap(40, true), ezMap(40, false));
        if (i == amount) line(x+i*offset.x, y+j*offset.y, x+(i+0.3)*offset.x, y+j*offset.y);
        else if (j != 0) line(x+i*offset.x, y+j*offset.y, x+(i+1)*offset.x, y+j*offset.y);
        if (j == amount-1) line(x+i*offset.x, y+j*offset.y, x+i*offset.x, y+(j+0.2)*offset.y);
        else line(x+i*offset.x, y+j*offset.y, x+i*offset.x, y+(j+1)*offset.y);
      }
    }

    textAlign(LEFT, TOP);
    displayText("Selected Sector: "+floor(selected.x+1), 10, 15);
    textAlign(RIGHT, BOTTOM);

    int with = 0;
    PVector temp = new PVector(0, 0);
    for (int j = 0; j < amount-1; j++) {
      for (int i = 0; i < amount; i++) {
        PVector offset = new PVector(map(40, 0, 1000, 0, width), map(40, 0, 600, 0, height));
        textSize(map(10, 0, 1600, 0, width+height));
        text(generateRandomNameS(index*1972394)+"-"+str(index+1), x + i*offset.x, y+j*offset.y, offset.x, offset.y);
        if (within(this, targetingPointLoc, x+i*offset.x, y+j*offset.y, offset.x, offset.y)) {
          with = index;
          temp = new PVector(i, j);
        }
        index++;
      }
    }
    if (isClicked) {
      selected.x = with;
      selectedSector = temp;
    }
  }

  void changePointPos(PVector direction) {
    if (within(new PVector(targetingPointLoc.x + direction.x, targetingPointLoc.y + direction.y), 0, 0, imageSize.x, imageSize.y)) {
      targetingPointLoc.x += direction.x;
      targetingPointLoc.y += direction.y;
    }
  }

  @Override
    void render() {
    println("wrong render dummy");
  }

  void render(Panel selectionPanel) {
    textSize(13);
    fill(255);
    update();
    if (selectionPanel.getSinglePanel(5, 0).clicked()) {
      isClicked = true;
    }
    switch(scene) {
    case 0:
      sectorMap();
      break;
    case 1:
      systemSelect(selectedSector);
      break;
    case 2:
      systemMap();
      break;
    default:
      drawRect(0, 0, w, h);
    }
    target(targetingPointLoc.x, targetingPointLoc.y, 5);
    noStroke();
    fill(0);
    drawRect(-2, -2, 12, 175);
    drawRect(218, 0, 10, 173);
    fill(0);
    drawRect(0, -100, originalSize.x, 110);
    drawRect(0, originalSize.y-10, originalSize.y, 2000);
    displayImage(tacticalSurrounds, 0, 0, 228, 173);
    isClicked = false;
  }

  PVector[] randomSysCoords(int amount) {
    PVector[] r = new PVector[amount];
    for (int i = 0; i < amount; i++) {
      r[i] = new PVector(random(10, w-10), random(30, h-40));
    }
    return r;
  }
}
