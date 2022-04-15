class AUXReadout extends Readout {
  AUXReadout(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  @Override
    void render() {
    update();
    switch(scene) {
    case 0:
      displayImage(surrounds, 0, 0);
      displayImage(federationLogo, 15, 15, originalSize.x-30, originalSize.y-30);
      break;
    case 1:
      displayImage(surrounds, 0, 0);
      fill(255);
      displayText("X: "+(mouseX-tacScreen.x)+"\nY: "+(mouseY-tacScreen.y), 40, 40);
      if(mousePressed && mousePressed != pMousePressed) println("X: "+(mouseX-tacScreen.x)+", Y: "+(mouseY-tacScreen.y));
      break;
    default:
      displayImage(surrounds, 0, 0);
      displayImage(federationLogo, 15, 15, originalSize.x-30, originalSize.y-30);
      break;
    }
  }
}
