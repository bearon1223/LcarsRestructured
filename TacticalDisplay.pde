class TacScreen extends Readout {
  Panel mainPanelL;
  Panel mainPanelR;
  Panel topPanel;

  TacScreen() {
    super(170+220, 0, 1000-(170+220), 600);
    mainPanelL = new Panel(this, 5, 150, 70, h-150).panelCount(1, 12);
    mainPanelR = new Panel(this, 105, 150, 70, h-150).panelCount(1, 12).setOneSideRounded().lastReversed();
    topPanel = new Panel(this, 5, 5, w-10, 145).panelCount(5, 1);
  }

  @Override
    void render() {
    update();
    displayImage(navTemplate, 0, 0);
    mainPanelL.render();
    mainPanelR.render();
    topPanel.render();
    circleButton(325, 360, 150, 150, null, null, null, null, null, null, null, null);
  }
}
