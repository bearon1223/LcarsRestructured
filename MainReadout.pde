class MainReadout extends Readout {
  Panel mainSystemsPanel;
  Panel navSystemsPanel;
  Panel navCenterPanel;
  Panel navTopPanel;
  Panel navBottomPanel;
  
  TacticalDisplay tD;

  MainReadout(float x, float y, float w, float h) {
    super(x, y, w, h);
    mainSystemsPanel = new Panel(this, 0, 0, w, h).panelCount(6, 5);
    navSystemsPanel = new Panel(this, 340, 150, 150, 150).panelCount(3, 6).setTextSize(5).setRounded();
    navCenterPanel = new Panel(this, 243, 120, 95, 211).panelCount(1, 4).addNames(navCenterPanelNames);
    navTopPanel = new Panel(this, 120, 0, w-125, 120).panelCount(6, 1).addNames(navTopPanelNames);
    navBottomPanel = new Panel(this, 0, 330, w, h-325).panelCount(7, 1).addNames(navBottomPanelNames);
    tD = new TacticalDisplay(x+10, y+150);
  }

  void target(float x, float y, float size) {
    stroke(#FFAD29);
    strokeWeight(3);
    drawLine(x-size, y, x+size, y);
    drawLine(x, y-size, x, y+size);
    strokeWeight(1);
    stroke(255);
  }
  
  //void systemSelect(PVector index, float x, float y){
  //  s[(int)index.x][(int)index.y].renderSector();
  //}

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
      navSystemsPanel.render();
      navCenterPanel.render();
      navTopPanel.render();
      navBottomPanel.render();

      int increment = 5;
      circleButton(10, 10, 100, 100, null, null, null, null, () -> changePointPos(new PVector(0, -increment)), () -> changePointPos(new PVector(0, increment)), () -> changePointPos(new PVector(-increment, 0)), () -> changePointPos(new PVector(increment, 0)));
      circleButton(890 - originalCoords.x, 400 - originalCoords.y, 100, 100, null, null, null, null, null, null, null, null);
      tD.render(navTopPanel);

      if (navTopPanel.getSinglePanel(0, 0).clicked()) {
        tD.scene = 0;
      } else if (navTopPanel.getSinglePanel(1, 0).clicked()) {
        tD.scene = 1;
      } else if (navTopPanel.getSinglePanel(2, 0).clicked()) {
        tD.scene = 2;
      } 
      break;
    default:
      textAlign(CENTER, CENTER);
      fill(#D8A600);
      displayText("LCARS was unable to find requested information\nPanel Number: "+scene, w/2, h/2);
    }
  }
}
