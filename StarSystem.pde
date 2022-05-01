class StarSystem {
  Sector s;
  Planet[] p;
  PVector loc;
  int id, r = 15, planetAmount;

  StarSystem(Sector s, PVector loc, int id, int planetAmount) {
    p = new Planet[planetAmount];
    this.s = s;
    r = round(random(10, 20));
    this.planetAmount = planetAmount;
    this.loc = new PVector(loc.x+s.tacticalDisplayLoc.x, loc.y+s.tacticalDisplayLoc.y);
    this.id = id;
    for (int i = 0; i < planetAmount; i++) {
      p[i] = new Planet(i);
    }
  }

  StarSystem(Sector s, PVector loc, int id) {
    this(s, loc, id, round(random(2, 4)));
  }

  void chooseColor() {
    if (r < 14) fill(255, 50, 50);
    else if (r < 18) fill(255, 255, 0);
    else fill(100, 100, 255);
  }

  Planet getPlanet (int id) {
    return p[constrain(id, 0, planetAmount-1)];
  }

  void renderSystem() {
    chooseColor();
    mapEllipse(loc.x, loc.y, r, r);
    textAlign(CENTER, CENTER);
    textSize(map(10, 0, 1600, 0, width+height));
    fill(255);
    displayText(str(id+1), loc.x-r/2, loc.y+r/2, r, r);
  }

  void renderSystemTiny(TacticalDisplay t, PVector offset, PVector arrayID) {
    //random(10, w-10), random(30, h-40);w=228, h=173
    noStroke();
    //if(arrayID.x==1 && arrayID.y == 1) println(loc.x);
    chooseColor();
    mapEllipse(t.originalCoords.x + ((offset.x) * (arrayID.x)) + map(loc.x - t.originalCoords.x, 0, t.limits.y, 3, 37),
      t.originalCoords.y + ((offset.y) * (arrayID.y)) + map(loc.y - t.originalCoords.y, 0, t.limits.w, 3, 37),
      map(r, 0, 20, 0, 5), map(r, 0, 20, 0, 5));
  }

  void renderPlanets(float yCoord) {
    chooseColor();
    noStroke();
    mapArc(410, yCoord, r*3.333, r*3.333, -HALF_PI, HALF_PI);
    fill(255, 255, 0);
    noFill();
    stroke(255);
    mapArc(410, yCoord, 80, 80, -HALF_PI, HALF_PI);
    mapArc(410, yCoord, 160, 160, -HALF_PI, HALF_PI);
    if (planetAmount >= 3) mapArc(410, yCoord, 260, 260, -HALF_PI, HALF_PI);
    if (planetAmount >= 4) mapArc(410, yCoord, 180*2, 180*2, -HALF_PI, HALF_PI);
    noStroke();
    for (int i = 0; i < planetAmount; i++) {
      p[i].render(yCoord);
    }
    fill(255);
  }

  void displayText(String text, float x, float y, float w, float h) {
    text(text, ezMap(x, true), ezMap(y, false), ezMap(w, true), ezMap(h, false));
  }

  float distanceSystem(PVector startingLoc) {
    return abs(hypotenuse(startingLoc.x-loc.x, startingLoc.y-loc.y));
  }
}

class Planet {
  int id;
  float size;
  Ship shipTest;

  Planet(int id, float size) {
    this.id = id;
    this.size = size;
    shipTest = new Ship(id, new PVector(1, 1, 1));
  }

  Planet(int id) {
    this(id, 15);
    if (id != 0) this.size = random(15, 40);
  }

  void render(float yCoord) {
    if (size < 20) fill(#AFAFAF);
    else if (size < 30) fill(#35DCED);
    else fill(#F5D18F);
    noStroke();
    if (id == 0) mapEllipse(450, yCoord, size, size);
    if (id == 1) mapEllipse(490, yCoord, size, size);
    if (id == 2) mapEllipse(540, yCoord, size, size);
    if (id == 3) mapEllipse(590, yCoord, size, size);
  }

  void renderPlanetSystem(PVector tDloc, PVector tDsize, float yCoord) {
    if (size < 20) fill(#AFAFAF);
    else if (size < 30) fill(#35DCED);
    else fill(#F5D18F);
    noStroke();
    mapEllipse(tDloc.x+tDsize.x/2, yCoord, size*2, size*2);
    
    fill(255);
    mapEllipse(map(shipTest.loc.y, 0, 100, tDloc.x, tDloc.x+tDsize.x), map(shipTest.loc.z, 0, 100, tDloc.y, tDloc.y+tDsize.y), 5, 5);
    //mapEllipse(map(shipTest.targetCoords.y, 0, 100, tDloc.x, tDloc.x+tDsize.x), map(shipTest.targetCoords.z, 0, 100, tDloc.y, tDloc.y+tDsize.y), 5, 5);

    fill(50, 50, 255);
    if (shipCoordinates.x == id) mapEllipse(map(shipCoordinates.y, 0, 100, tDloc.x, tDloc.x+tDsize.x), map(shipCoordinates.z, 0, 100, tDloc.y, tDloc.y+tDsize.y), 5, 5);
  }

  void update() {
    shipTest.update();
    if (shipTest.isAtCoords(shipTest.targetCoords)) shipTest.targetCoords = shipTest.pickPoint(id, false);
    shipTest.goToCoords(shipTest.targetCoords);
  }
}
