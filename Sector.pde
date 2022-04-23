class Sector {
  StarSystem[] s;
  int id, systemAmount;
  PVector tacticalDisplayLoc, arrayID;

  Sector(PVector tacticalDisplayLoc, PVector arrayID, int id, int systemAmount, PVector[] systemCoords) {
    this.id = id;
    this.arrayID = arrayID;
    this.systemAmount = systemAmount;
    this.tacticalDisplayLoc = tacticalDisplayLoc;
    s = new StarSystem[systemAmount];
    for (int i = 0; i < systemAmount; i++) {
      s[i] = new StarSystem(this, systemCoords[i], i);
    }
  }

  Sector(PVector tacticalDisplayLoc, PVector arrayID, int id, PVector[] systemCoords) {
    this(tacticalDisplayLoc, arrayID, id, round(random(3, 7)), systemCoords);
  }

  StarSystem getSystem(int i) {
    return s[i];
  }

  void renderSector() {
    for (int i = 0; i < systemAmount; i++) {
      s[i].renderSystem();
    }
  }
  
  void renderTiny(TacticalDisplay t, PVector offset){
    //println(arrayID);
    for (int i = 0; i < systemAmount; i++){
      s[i].renderSystemTiny(t, offset, arrayID);
    }
  }

  float distanceSector(PVector fromID) {
    return abs(hypotenuse(fromID.x-arrayID.x, fromID.y-arrayID.y));
  }
}
