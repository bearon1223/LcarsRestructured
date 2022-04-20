class TacScreen extends Readout {
  Panel mainPanelL;
  Panel mainPanelR;
  Panel topPanel;

  TacScreen() {
    super(170+220, 0, 1000-(170+220), 600);
    mainPanelL = new Panel(this, 5, 150, 70, h-150).panelCount(1, 12);
    mainPanelR = new Panel(this, 105, 150, 70, h-150).panelCount(1, 12).setOneSideRounded().lastReversed();
    topPanel = new Panel(this, 5, 5, w-10, 145).panelCount(5, 1);
    shields = new Shields(x+175, 150);
  }

  @Override
    void render() {
    update();
    mainPanelL.render();
    mainPanelR.render();
    topPanel.render();
    shields.render();
    topPanel.getSinglePanel(4, 0).rename("Toggle Shields");
    topPanel.getSinglePanel(4, 0).clicked(() -> shields.isEnabled = !shields.isEnabled);
    circleButton(445, 435, 150, 150, null, null, null, null, null, null, null, null);
  }
}
