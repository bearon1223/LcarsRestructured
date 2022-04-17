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
    if(r < 14) fill(255, 50, 50);
    else if(r < 18) fill(255, 255, 0);
    else fill(100, 100, 255);
  }

  void renderSystem() {
    chooseColor();
    mapEllipse(loc.x, loc.y, r, r);
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
  }
}

class Planet {
  int id;
  float size;
  Planet(int id, float size) {
    this.id = id;
    this.size = size;
  }

  Planet(int id) {
    this(id, 15);
    if(id != 0) this.size = random(15, 40);
  }
  //(400), 347
  void render(float yCoord) {
    if (size < 20) fill(#AFAFAF);
    else if(size < 30) fill(#35DCED);
    else fill(#F5D18F);
    noStroke();
    if (id == 0) mapEllipse(450, yCoord, size, size);
    if (id == 1) mapEllipse(490, yCoord, size, size);
    if (id == 2) mapEllipse(540, yCoord, size, size);
    if (id == 3) mapEllipse(590, yCoord, size, size);
  }
}
