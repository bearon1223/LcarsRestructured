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
        s[i][j] = new Sector(new PVector(x, y), index, randomSysCoords(4));
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
    x+=10;
    fill(255, 255, 0);
    mapArc(originalCoords.x, originalCoords.y+originalSize.y/2, 50, 50, -HALF_PI, HALF_PI);
    noFill();
    stroke(255);
    mapArc(originalCoords.x, originalCoords.y+originalSize.y/2, 80, 80, -HALF_PI, HALF_PI);
    mapArc(originalCoords.x, originalCoords.y+originalSize.y/2, 160, 160, -HALF_PI, HALF_PI);
    if (s[(int)selectedSector.x][(int)selectedSector.y].getSystem(floor(selected.y)).planetAmount >= 3) mapArc(originalCoords.x, originalCoords.y+originalSize.y/2, 260, 260, -QUARTER_PI*0.8, QUARTER_PI*0.8);
    if (s[(int)selectedSector.x][(int)selectedSector.y].getSystem(floor(selected.y)).planetAmount >= 4) mapArc(originalCoords.x, originalCoords.y+originalSize.y/2, 180*2, 180*2, -QUARTER_PI/1.8, QUARTER_PI/1.8);
    
    s[(int)selectedSector.x][(int)selectedSector.y].getSystem(floor(selected.y)).renderPlanets(originalCoords.y+originalSize.y/2);
    
    fill(255);
    textAlign(LEFT, TOP);
    textSize(13);
    displayText("Selected: Sector"+floor(selected.x)+", System "+floor(selected.y) + ", \nPlanet " + floor(selected.z), 10, 15);
    textAlign(RIGHT, BOTTOM);
    originalCoords.x+=10;
    
    if (isClicked && within(this, targetingPointLoc, originalCoords.x, originalCoords.y+originalSize.y/2, 50)) {
      selected.z = 0;
    } else  if (isClicked && within(this, targetingPointLoc, originalCoords.x+40, originalCoords.y+originalSize.y/2, 15)) {
      selected.z = 1;
    } else if (isClicked && within(this, targetingPointLoc, originalCoords.x+80, originalCoords.y+originalSize.y/2, 27)) {
      selected.z = 2;
    } else if (isClicked && within(this, targetingPointLoc, originalCoords.x+130, originalCoords.y+originalSize.y/2, 30)) {
      selected.z = 3;
    } else if (isClicked && within(this, targetingPointLoc, originalCoords.x+180, originalCoords.y+originalSize.y/2, 20)) {
      selected.z = 4;
    }
    x-=10;
    originalCoords.x-=10;
  }

  void systemSelect(PVector index) {
    textAlign(LEFT, TOP);
    displayText("Selected Sector: "+floor(selected.x)+", Selected System: "+floor(selected.y), 10, 15);
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
    displayText("Selected Sector: "+floor(selected.x), 10, 15);
    textAlign(RIGHT, BOTTOM);

    int with = 0;
    PVector temp = new PVector(0, 0);
    for (int j = 0; j < amount-1; j++) {
      for (int i = 0; i < amount; i++) {
        PVector offset = new PVector(map(40, 0, 1000, 0, width), map(40, 0, 600, 0, height));
        textSize(map(10, 0, 1600, 0, width+height));
        text(generateRandomNameS(index*1972394)+"-"+str(index), x + i*offset.x, y+j*offset.y, offset.x, offset.y);
        if (within(this, targetingPointLoc, x+i*offset.x, y+j*offset.y, offset.x, offset.y)) {
          with = index;
          temp = new PVector(i, j);
          println(index);
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

  void render(Panel selectionPanel) {
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
