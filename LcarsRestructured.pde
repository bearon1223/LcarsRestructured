import processing.sound.*;

Panel mainSideMenu;
Panel midMenu;
Panel smallSettingsPanel;
Panel statusButtonR;
Panel statusButtonL;
Panel mainViewSideMenuU;
Panel mainViewSideMenuB;
Panel upperButtons;

TertiaryReadout tReadout;
AUXReadout aReadout;
MainReadout mReadout;
SecondaryReadout sReadout;
TacScreen tacScreen;

Warpcore wc;
Impulse impulse;
Batteries batteries;
Shields shields;

PImage icon;

PImage federationLogo;
PImage standbyScreen;
PImage surrounds;
PImage tacticalSurrounds;
PImage template;
PImage template2;
PImage circleButton;
PImage navTemplate;

// SectorX, SectorY, SystemID, PlanetID
PVector coordinates = new PVector(0, 0, 1);
// Planet, X, Y
PVector shipCoordinates = new PVector(0, 0, 0);

PFont f;
Sector[][] s;

Timer reset;

SoundFile click;
SoundFile failClick;

boolean pMousePressed = false;
boolean isOver = false;
boolean isTraveling = false;

float selectedSpeed = 0;

int sceneMain = 0;

void settings() {
  size (1000, 600);
  f = loadFont("Impact-48.vlw");
}

void setup() {
  mainSideMenu       = new Panel(170, 5, 110, 595).panelCount(new PVector(1, 7)).addNames(mainSideMenuNames);
  mainViewSideMenuU  = new Panel(170 + 110, 5, new PVector(110, 226.871401152)).panelCount(1, 2);
  mainViewSideMenuB  = new Panel(170 + 110, 231.871401152, new PVector(110, 600 - 231.871401152)).panelCount(1, 8);
  midMenu            = new Panel(mainViewSideMenuU.x + mainViewSideMenuU.size.x, 207, new PVector(1000 - (mainViewSideMenuU.x + mainViewSideMenuU.size.x), 25)).panelCount(new PVector(7, 1));
  smallSettingsPanel = new Panel(7, 420, 160, 151).panelCount(2, 4).addNames(smallSettingsPanelNames).setOneSideRounded().lastReversed();
  statusButtonL      = new Panel(7, 141.650671785, 80, 151).panelCount(1, 4).setOneSideRounded();
  statusButtonR      = new Panel(87, 141.650671785, 80, 151).panelCount(1, 4);
  upperButtons       = new Panel(1000-180, 50, 180, 113.25).panelCount(2, 3).setRounded().addNames(upperButtonsNames);

  tReadout = new TertiaryReadout(7, 141.65+151, 155, 120);
  sReadout = new SecondaryReadout(390, 5, 1000-395 - 180, 195);
  aReadout = new AUXReadout(5, 5, mainSideMenu.x-10, statusButtonR.y-10);
  mReadout = new MainReadout(midMenu.x, midMenu.y+midMenu.size.y, width - midMenu.x - 5, height - (midMenu.y + midMenu.size.y) - 5);

  tacScreen = new TacScreen();

  reset = new Timer(2);

  click = new SoundFile(this, "Click.wav");
  click.amp(0.125);
  failClick = new SoundFile(this, "Deny.wav");
  failClick.amp(0.125);

  federationLogo    = loadImage("Federation Logo.jpg");
  standbyScreen     = loadImage("Federation Standby.jpg");
  surrounds         = loadImage("Image Surroundings.png");
  tacticalSurrounds = loadImage("Tactical Display Surroundings.png");
  template          = loadImage("Helm1.png");
  template2         = loadImage("Tactical Display Template.png");
  circleButton      = loadImage("Circle Button.png");
  navTemplate       = loadImage("Nav Panel.jpg");
  icon              = loadImage("icon.png");

  surface.setTitle("LCARS");
  surface.setResizable(true);
  surface.setIcon(icon);
}

void draw() {
  isOver = false;
  textFont(f);
  noStroke();
  background(0);
  textAlign(RIGHT, BOTTOM);

  wc.update();
  impulse.update();
  batteries.update();
  shields.update();

  s[(int)convertIndexToVector(coordinates.x).x][(int)convertIndexToVector(coordinates.x).y].getSystem((int)coordinates.y).getPlanet((int)coordinates.z).update();

  //travel(TacticalDisplay tD, Sector current, Sector destination, StarSystem currentS, StarSystem destinationS, boolean startTravel, float speed) One beefy function jesus christ
  wc.travel(mReadout.tD,
    s[(int)mReadout.tD.currentSector.x][(int)mReadout.tD.currentSector.y],
    s[(int)mReadout.tD.selectedSector.x][(int)mReadout.tD.selectedSector.y],
    s[(int)mReadout.tD.currentSector.x][(int)mReadout.tD.currentSector.y].getSystem((int)coordinates.y),
    s[(int)mReadout.tD.selectedSector.x][(int)mReadout.tD.selectedSector.y].getSystem((int)mReadout.tD.selected.y),
    isTraveling, selectedSpeed);

  switch(sceneMain) {
  case 0:
    fill(100, 150, 255);
    mapRect(20, 20, 960, 20, 100);
    mapRect(20, 560, 960, 20, 100);
    mapImage(federationLogo, 250, 300 - 394/2, 500, 394);
    if (keyPressed && (key == ENTER || key == RETURN)) sceneMain = 1;
    break;
  case 1:
    // Default Screen
    mainSideMenu.render();
    midMenu.render();
    smallSettingsPanel.render();
    mainViewSideMenuU.render();
    mainViewSideMenuB.render();
    statusButtonR.render();
    statusButtonL.render();
    upperButtons.render();

    tReadout.render();
    aReadout.render();
    sReadout.render();
    mReadout.render();

    mainSideMenu.clickArray(mReadout, mainSideMenuClickID);
    upperButtons.getSinglePanel(0, 0).clicked(() -> mReadout.scene = 0);
    smallSettingsPanelButtons();
    break;
  case 2:
    // Tactical Display
    mainSideMenu.render();
    smallSettingsPanel.render();
    mainViewSideMenuU.render();
    mainViewSideMenuB.render();
    statusButtonR.render();
    statusButtonL.render();

    tReadout.render();
    aReadout.render();

    mainSideMenu.clickArray(mReadout, mainSideMenuClickID);
    button(mainSideMenu.x, mainSideMenu.y, mainSideMenu.size.x, mainSideMenu.size.y, () -> resetNotMain());
    smallSettingsPanelButtons();

    tacScreen.render();
    break;
  default:
    background(255, 0, 255);
    fill(0);
    textSize(50);
    text("No Scene Available", width/2, height/2);
    if (reset.countTimer()) {
      sceneMain = 0;
      reset.resetTimer();
    }
  }
  if (isOver) cursor(HAND);
  else cursor(ARROW);
  pMousePressed = mousePressed;
}

void smallSettingsPanelButtons() {
  smallSettingsPanel.getSinglePanel(0, 3).clicked(() -> exit());
  smallSettingsPanel.getSinglePanel(1, 1).clicked(() -> println(frameRate));
  smallSettingsPanel.getSinglePanel(0, 0).clicked(() -> reset());
}

void reset() {
  sceneMain = 1;
  aReadout.scene = 0;
  mReadout.scene = 0;
}

void resetNotMain() {
  sceneMain = 1;
  aReadout.scene = 0;
}
