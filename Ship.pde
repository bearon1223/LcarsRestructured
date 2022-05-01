class Ship {
  Warpcore wc;
  Batteries bat;
  Shields shields;
  Hull hull;

  // Planet, X, Y
  PVector loc;
  PVector targetCoords;

  boolean isDestroyed = false;
  boolean isAttacking = false;
  
  int id;

  Ship(int id, PVector loc, boolean shieldsUp, float startingPower, float startingHull) {
    bat = new Batteries(0, 0, 0);
    wc = new Warpcore(bat, 0, 0, 0, 0);
    shields = new Shields(0, 0);
    hull = new Hull();

    this.loc = loc;
    this.targetCoords = loc;
    this.id = id;

    shields.isEnabled = shieldsUp;
    bat.power = constrain(startingPower, 0, 100);
    hull.HP = constrain(startingHull, 0, 100);
  }
  
  Ship(PVector loc, Warpcore wc, Shields shields, Batteries bat, Hull hull) {
    this.loc = loc;
    this.wc = wc;
    this.shields = shields;
    this.bat = bat;
    this.hull = hull;
  }

  Ship(int id, PVector loc) {
    this(id, loc, true, 100, 100);
  }

  PVector pickPoint(float Planet, boolean isAttacking) {
    this.isAttacking = isAttacking;
    if (!isAttacking) return new PVector(Planet, random(0, 100), random(0, 100));
    else return new PVector(Planet, shipCoordinates.x, shipCoordinates.y);
  }

  void goToCoords(PVector coords, float speed) {
    if (!isAtCoords(coords)) {
      if (loc.x == coords.x) {
        if (loc.y < coords.y) loc.y += speed;
        if (loc.y > coords.y) loc.y -= speed;
        float slope = constrain(loc.z-coords.z, 1, 50)/constrain(loc.y-coords.y, 5, 100);
        //if (loc.z < coords.z) loc.z += speed*slope;
        //if (loc.z > coords.z) loc.z -= speed*slope;
        if(loc.z < coords.z) loc.z += slope;
        if(loc.z > coords.z) loc.z -= slope;
        //println(coords);
        //println("LOC: "+loc);
        //println(slope);
        //y-yCoord = slope(x-xCoord)
        //println("isRun");
      } else pickPoint(loc.x, isAttacking);
    }
  }
  
  void goToCoords (PVector coords){
    goToCoords(coords, 0.1);
  }
  
  boolean isAtCoords(PVector coords) {
    return within(new PVector(loc.y, loc.z), coords.y-5, coords.z-5, 10, 10);
  }
  
  void testPrint(){
    println("wc enabled: "+wc.isEnabled);
    println("shield enabled: "+shields.isEnabled);
    println("bats: "+bat.power);
    println("loc: "+loc);
    println(isAttacking);
  }

  void update() {
    if (hull.HP < 0) {
      isDestroyed = true;
      wc.isEnabled = false;
      bat.power = 0;
      shields.isEnabled = false;
    } else {
      bat.update();
      shields.update();
      wc.update();
    }
  }
}
