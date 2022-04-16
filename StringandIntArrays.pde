String[][] smallSettingsPanelNames = {
  {"LCARS", "EXTERIOR"},
  {"LOCK", "SYS INFO"},
  {"SYS TIME", "SETTINGS"},
  {"DEACTIVATE", "ONLINE"},
};


String[][] navBottomPanelNames = {
  {"WARP 1", "WARP 2", "WARP 3", "WARP 4", "WARP 5", "WARP 6", "WARP 7"}
};

String[][] navTopPanelNames = {
  {"SECTOR MAP", "SYSTEMS MAP", "PLANETARY SYSTEM MAP", "FEDERATION MAP", "POLITICAL MAP", "SELECT"}
};

String[][] navCenterPanelNames = {
  {"FULL STOP"},
  {"33% IMPULSE"},
  {"66% IMPULSE"},
  {"FULL IMPULSE"}
};



String[][] mainSideMenuNames = {
  {"SYS DIRECTORY"},
  {"AUX DIRECTORY"},
  {"MED DIRECTORY"},
  {"COMMUNICATION"},
  {"STELLAR CARTOGRAPHY"},
  {"MISSION OPS"},
  {"DATABASE"},
};

int [][]mainSideMenuClickID = {
  {1},
  {2},
  {3},
  {4},
  {5},
  {6},
  {7},
};



String[][] navPanelNames = {
  {"Warp 7"},
  {"Warp 6"},
  {"Warp 5"},
  {"Warp 4"},
  {"Warp 3"},
  {"Warp 2"},
  {"Warp 1"},
  {"Impulse"},
};

String[][] upperButtonsNames = {
  {"BACK", generateRandomName()},
  {generateRandomName(), generateRandomName()},
  {generateRandomName(), generateRandomName()},
  {generateRandomName(), generateRandomName()},
};

String generateRandomName(float seed) {
  push();
  randomSeed((long)seed);
  String[] number = new String[9];
  number[0] = str(round(random(1, 9)));
  number[1] = str(round(random(1, 9)));
  number[2] = "-";
  number[3] = str(round(random(1, 9)));
  number[4] = str(round(random(1, 9)));
  number[5] = str(round(random(1, 9)));
  number[6] = str(round(random(1, 9)));
  number[7] = str(round(random(1, 9)));
  number[8] = str(round(random(1, 9)));
  pop();
  String output = String.join("", number);
  return output;
}

String generateRandomNameS(float seed) {
  push();
  randomSeed((long)seed);
  String[] number = new String[5];
  number[0] = str(round(random(1, 9)));
  number[1] = "-";
  number[2] = str(round(random(1, 9)));
  number[3] = str(round(random(1, 9)));
  number[4] = str(round(random(1, 9)));
  pop();
  String output = String.join("", number);
  return output;
}

String generateRandomName() {
  String[] number = new String[9];
  number[0] = str(round(random(1, 9)));
  number[1] = str(round(random(1, 9)));
  number[2] = "-";
  number[3] = str(round(random(1, 9)));
  number[4] = str(round(random(1, 9)));
  number[5] = str(round(random(1, 9)));
  number[6] = str(round(random(1, 9)));
  number[7] = str(round(random(1, 9)));
  number[8] = str(round(random(1, 9)));
  String output = String.join("", number);
  return output;
}
