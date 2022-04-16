class StarSystem {
  Sector s;
  PVector loc;
  int id;
  
  StarSystem(Sector s, PVector loc, int id) {
    this.s = s;
    this.loc = new PVector(loc.x+s.tacticalDisplayLoc.x, loc.y+s.tacticalDisplayLoc.y);
    this.id = id;
  }
  
  void render() {
    fill(255, 0, 255);
    mapEllipse(loc.x, loc.y, 5, 5);
  }
}
