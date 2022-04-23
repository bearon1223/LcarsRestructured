class Ship {
  Warpcore wc;
  Batteries bat;
  Shields shields;
  Hull hull;

  // Planet, X, Y
  PVector loc;
  PVector targetCoords;

  boolean isDestroyed = false;

  Ship(PVector loc, boolean shieldsUp, float startingPower, float startingHull) {
    bat = new Batteries(0, 0, 0);
    wc = new Warpcore(bat, 0, 0, 0, 0);
    shields = new Shields(0, 0);
    hull = new Hull();

    this.loc = loc;
    this.targetCoords = loc;

    shields.isEnabled = shieldsUp;
    bat.power = constrain(startingPower, 0, 100);
    hull.HP = constrain(startingHull, 0, 100);
  }

  Ship(PVector loc) {
    this(loc, true, 100, 100);
  }

  PVector pickPoint(float Planet, boolean isAttacking) {
    if (!isAttacking) return new PVector(Planet, random(0, 100), random(0, 100));
    else return new PVector(Planet, shipCoordinates.x, shipCoordinates.y);
  }

  void goToCoords(PVector coords, float speed) {
    if (!isAtCoords(coords)) {
      if (loc.x == coords.x) {
        if (loc.y < coords.y) loc.y += speed;
        if (loc.y > coords.y) loc.y -= speed;
        if (loc.z < coords.z) loc.z += speed;
        if (loc.z > coords.z) loc.z -=speed;
        //println(loc);
      }
    }
  }
  
  void goToCoords (PVector coords){
    goToCoords(coords, 0.1);
  }

  boolean isAtCoords(PVector coords) {
    return floor(loc.x) == floor(coords.x) && floor(coords.y) == floor(loc.y);
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
