class TacScreen extends Readout {
  Panel mainPanelL;
  Panel mainPanelR;
  Panel topPanel;
  Ship selectedShip;

  TacScreen() {
    super(170+220, 0, 1000-(170+220), 600);
    mainPanelL = new Panel(this, 5, 150, 70, h-150).panelCount(1, 12);
    mainPanelR = new Panel(this, 105, 150, 70, h-150).panelCount(1, 12).setOneSideRounded().lastReversed();
    topPanel = new Panel(this, 5, 5, w-10, 145).panelCount(5, 1);
    shields = new Shields(x+175, 150);
  }

  @Override
    void update() {
    super.update();
    selectedShip = s[(int)convertIndexToVector(coordinates.x).x][(int)convertIndexToVector(coordinates.x).y].getSystem((int)coordinates.y).getPlanet((int)coordinates.z).shipTest;
  }

  @Override
    void render() {
    update();
    mainPanelL.render();
    mainPanelR.render();
    topPanel.render();
    shields.render();
    topPanel.getSinglePanel(4, 0).rename("Toggle Shields");
    topPanel.getSinglePanel(4, 0).clicked(() -> {
      shields.isEnabled = !shields.isEnabled;
      if (shields.powerLevel > 45) shields.powerLevel = 35;
      else shields.powerLevel = 0;
    }
    );
    topPanel.getSinglePanel(3, 0).rename("Follow Ship");
    topPanel.getSinglePanel(3, 0).clicked(() -> mainShip.isAttacking = !mainShip.isAttacking);

    PVector shipCoords = s[(int)convertIndexToVector(coordinates.x).x][(int)convertIndexToVector(coordinates.x).y].getSystem((int)coordinates.y).getPlanet((int)coordinates.z).shipTest.loc;
    if (mainShip.isAttacking) mainShip.goToCoords(shipCoords, 0.1);
    //topPanel.
    fill(255);
    textSize(map(13, 0, 1600, 0, width+height));
    textAlign(LEFT, TOP);
    displayText("Target Ship Hull Status: "+selectedShip.hull.HP+
      "\nTarget Ship Shield Level: "+selectedShip.shields.powerLevel+
      "\nTarget Ship Battery Level: "+constrain(selectedShip.bat.power, 0, 100)+
      "\nTarget Ship Location: "+round(map(selectedShip.loc.y, 0, 100, -50, 50))+", "+round(-map(selectedShip.loc.z, 0, 100, -50, 50))
      , 180, 350, originalSize.x-185, 100);

    displayText("Ship Hull Status: "+mainShip.hull.HP+
      "\nShip Shield Level: "+mainShip.shields.powerLevel+
      "\nShip Battery Level: "+round(constrain(mainShip.bat.power, 0, 100))+
      "\nShip Location: "+round(map(mainShip.loc.y, 0, 100, -50, 50))+", "+round(-map(mainShip.loc.z, 0, 100, -50, 50))
      , 450, 350, originalSize.x-450, 100);

    circleButton(445, 435, 150, 150, null, null, null, null, null, null, null, null);

    //Show Planet
    s[(int)convertIndexToVector(coordinates.x).x][(int)convertIndexToVector(coordinates.x).y]
      .getSystem((int)coordinates.y).getPlanet((int)coordinates.z).renderPlanetSystem(new PVector(originalCoords.x+180, 420), new PVector(228, 173), (420)+(173/2));

    noStroke();
    fill(0);
    drawRect(178, 418, 12, 175);
    drawRect(218+180, 420, 10, 173);
    displayImage(tacticalSurrounds, 180, 420, 228, 173);

    fill(255);
    textAlign(LEFT, TOP);
    textSize(13);
    displayText("Sector: "+floor(coordinates.x+1)+", System: "+floor(coordinates.y+1) + ", Planet: " + floor(coordinates.z+1), 210, 420);
    textAlign(RIGHT, BOTTOM);
  }
}
