class StarSystem {
  Sector s;
  Planet[] p;
  PVector loc;
  int id, r = 15, planetAmount;

  StarSystem(Sector s, PVector loc, int id, int planetAmount) {
    p = new Planet[planetAmount];
    this.s = s;
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

  void renderSystem() {
    fill(255, 255, 0);
    mapEllipse(loc.x, loc.y, r, r);
  }

  void renderPlanets(float yCoord) {
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
    if (id == 0) mapEllipse(400+40, yCoord, size, size);
    if (id == 1) mapEllipse(400+80, yCoord, size, size);
    if (id == 2) mapEllipse(400+130, yCoord, size, size);
    if (id == 3) mapEllipse(400+180, yCoord, size, size);
  }
}
