class Sector {
  StarSystem[] s;
  int id, systemAmount;
  PVector tacticalDisplayLoc;

  Sector(PVector tacticalDisplayLoc, int id, int systemAmount, PVector[] systemCoords) {
    this.id = id;
    this.systemAmount = systemAmount;
    this.tacticalDisplayLoc = tacticalDisplayLoc;
    s = new StarSystem[systemAmount];
    for (int i = 0; i < systemAmount; i++) {
      s[i] = new StarSystem(this, systemCoords[i], i);
    }
  }

  Sector(PVector tacticalDisplayLoc, int id, PVector[] systemCoords) {
    this(tacticalDisplayLoc, id, round(random(3, 7)), systemCoords);
  }

  StarSystem getSystem(int i) {
    return s[i];
  }
  
  void renderSector() {
    for(int i = 0; i < systemAmount; i++) {
      s[i].renderSystem();
    }
  }
}
