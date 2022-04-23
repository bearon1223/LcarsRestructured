class MainReadout extends Readout {
  Panel mainSystemsPanel;

  Panel navSystemsPanel;
  Panel navCenterPanel;
  Panel navTopPanel;
  Panel navBottomPanel;

  Panel auxMainPanel;
  Panel auxSidePanel;

  TacticalDisplay tD;

  MainReadout(float x, float y, float w, float h) {
    super(x, y, w, h);
    mainSystemsPanel = new Panel(this, 0, 0, w, h).panelCount(6, 5);

    tD = new TacticalDisplay(x+10, y+150);
    navSystemsPanel = new Panel(this, 340, 150, 150, 150).panelCount(3, 6).setTextSize(5).setRounded();
    navCenterPanel = new Panel(this, 243, 120, 95, 211).panelCount(1, 4).addNames(navCenterPanelNames);
    navTopPanel = new Panel(this, 120, 0, w-125, 120).panelCount(6, 1).addNames(navTopPanelNames);
    navBottomPanel = new Panel(this, 0, 330, w, h-325).panelCount(7, 1).addNames(navBottomPanelNames);

    auxMainPanel = new Panel(this, 160, 10, 450, 100).panelCount(5, 1).addNames(auxMainPanelNames);
    auxSidePanel = new Panel(this, w-125, 110, 130, h-110).panelCount(1, 5).addNames(auxSidePanelNames);

    batteries = new Batteries(x+175+155, auxSidePanel.y, auxSidePanel.originalSize.y);
    wc = new Warpcore(batteries, x+10, y+10);
    impulse = new Impulse(batteries, x+25+wc.w, w-75);
  }

  void target(float x, float y, float size) {
    stroke(#FFAD29);
    strokeWeight(3);
    drawLine(x-size, y, x+size, y);
    drawLine(x, y-size, x, y+size);
    strokeWeight(1);
    stroke(255);
  }

  void changePointPos(PVector direction) {
    tD.changePointPos(direction);
  }

  @Override
    void render() {
    update();
    switch(scene) {
    case 0:
      displayImage(standbyScreen, 0, 10);
      break;
    case 1:
      // System Directory
      mainSystemsPanel.render();
      mainSystemsPanel.getSinglePanel(5, 0).rename("Naviagation");
      mainSystemsPanel.getSinglePanel(5, 1).rename("Tactical");

      if (mainSystemsPanel.getSinglePanel(5, 1).clicked()) {
        sceneMain = 2;
        aReadout.scene = 1;
      }
      mainSystemsPanel.getSinglePanel(5, 0).clicked(() -> scene = 11);

      break;
    case 11:
      //Navigational Panel
      tD.render(navTopPanel);
      navSystemsPanel.render();
      navCenterPanel.render();
      navTopPanel.render();
      navBottomPanel.render();

      int increment = 5;
      circleButton(10, 10, 100, 100, null, null, null, null, () -> changePointPos(new PVector(0, -increment)), () -> changePointPos(new PVector(0, increment)), () -> changePointPos(new PVector(-increment, 0)), () -> changePointPos(new PVector(increment, 0)));
      circleButton(890 - originalCoords.x, 400 - originalCoords.y, 100, 100, null, null, null, null, null, null, null, null);

      if (second() % 2 == 0 && (!wc.isEnabled || wc.powerRerouted)) fill(255, 100, 100);
      else fill(255);
      textAlign(LEFT, CENTER);
      if (!wc.isEnabled || wc.powerRerouted) displayText("Error: No Active Core", 10, 130, tD.originalSize.x, 20);
      else if (wc.travelDistance-wc.traveledDistance != 0) displayText("Distance Left: "+str(round(wc.travelDistance-wc.traveledDistance)), 10, 130, tD.originalSize.x, 20);
      else displayText("At Destination", 10, 130, tD.originalSize.x, 20);
      textAlign(RIGHT, BOTTOM);
      if (navTopPanel.getSinglePanel(0, 0).clicked()) {
        tD.scene = 0;
      } else if (navTopPanel.getSinglePanel(1, 0).clicked()) {
        tD.scene = 1;
      } else if (navTopPanel.getSinglePanel(2, 0).clicked()) {
        tD.scene = 2;
      } else if (navTopPanel.getSinglePanel(3, 0).clicked()) {
        tD.scene = 3;
      } else if (navTopPanel.getSinglePanel(4, 0).clicked()) {
        tD.selected = new PVector(coordinates.x, coordinates.y, coordinates.z);
        tD.selectedSector = convertIndexToVector(coordinates.x);
        tD.scene = 3;
      }
      if (navBottomPanel.getSinglePanel(0, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 1;
      } else if (navBottomPanel.getSinglePanel(1, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 2;
      } else if (navBottomPanel.getSinglePanel(2, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 3;
      } else if (navBottomPanel.getSinglePanel(3, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 4;
      } else if (navBottomPanel.getSinglePanel(4, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 5;
      } else if (navBottomPanel.getSinglePanel(5, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 6;
      } else if (navBottomPanel.getSinglePanel(6, 0).clicked(!wc.powerRerouted && wc.isEnabled)) {
        isTraveling = true;
        selectedSpeed = 7;
      } 
      break;
    case 2:
      // AUX Directory/Ship Status
      wc.render();
      impulse.render();
      batteries.render();

      auxMainPanel.render();
      auxSidePanel.render();

      auxMainPanel.getSinglePanel(0, 0).clicked(() -> wc.scene = 1);
      auxMainPanel.getSinglePanel(1, 0).clicked(() -> wc.powerRerouted = !wc.powerRerouted);
      auxMainPanel.getSinglePanel(2, 0).clicked(() -> wc.isEnabled = true);
      auxMainPanel.getSinglePanel(3, 0).clicked(() -> wc.isEnabled = false);
      //auxMainPanel.getSinglePanel(4, 0).clicked(null);

      //auxSidePanel.getSinglePanel(0, 0).clicked(null);
      auxSidePanel.getSinglePanel(0, 1).clicked(() -> impulse.isEnabled = false);
      auxSidePanel.getSinglePanel(0, 2).clicked(() -> impulse.isEnabled = true);
      if (auxSidePanel.getSinglePanel(0, 3).clicked() && !impulse.powerRerouted && impulse.isEnabled) impulse.powerSave = !impulse.powerSave;
      if (auxSidePanel.getSinglePanel(0, 4).clicked() && !impulse.powerSave && impulse.isEnabled) impulse.powerRerouted = !impulse.powerRerouted;
      break;
    default:
      textAlign(CENTER, CENTER);
      fill(#D8A600);
      displayText("LCARS was unable to find requested information\nPanel Number: "+scene, w/2, h/2);
    }
  }
}
