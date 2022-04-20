class Ship {
  Warpcore wc;
  Batteries bat;
  Shields shields;
  Hull hull;
  PVector loc;
  boolean isDestroyed = false;
  
  Ship(PVector loc, boolean shieldsUp, float startingPower, float startingHull) {
    bat = new Batteries(0, 0, 0);
    wc = new Warpcore(bat, 0, 0, 0, 0);
    shields = new Shields(0, 0);
    hull = new Hull();
    
    this.loc = loc;
    
    shields.isEnabled = shieldsUp;
    bat.power = constrain(startingPower, 0, 100);;
    hull.HP = constrain(startingHull, 0, 100);;
  }
  
  void update() {
    if(hull.HP < 0) {
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
