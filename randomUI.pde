class UIElement extends Readout {
  boolean isEnabled = true;
  boolean powerRerouted = false;

  UIElement(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  @Override
    void render() {
    fill(255);
    rect(x, y, w, h);
  }
}

class Batteries extends Readout {
  float power = 100;

  Batteries(float x, float y, float h) {
    super(x, y, 145, h);
  }

  @Override
    void render() {
    fill(#A7FFEA);
    noStroke();
    drawRect(10, originalSize.y-10, originalSize.x-20, -map(constrain(round(power/10), 0, 10), 0, 10, 0, originalSize.y-45), 10);
    for (int i = 1; i < 10; i++) {
      strokeWeight(5);
      stroke(0);
      float y = 35+i*(originalSize.y-45)/10;
      drawLine(10, y, originalSize.x-10, y);
    }
    stroke(#898989);
    noFill();
    strokeWeight(10);
    drawRect(10, 30, originalSize.x-20, originalSize.y-40, 25);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(map(15, 0, 1600, 0, width+height));
    displayText("Power Levels", 10, 0, originalSize.x-20, 30);
  }
}

class Warpcore extends UIElement {
  int segmantLight = 0;
  float travelDistance = 0;
  float traveledDistance = 0;
  Batteries bat;

  Warpcore(Batteries bat, float x, float y, float w, float h) {
    super(x, y, w, h);
    this.bat = bat;
  }

  Warpcore(Batteries bat, float x, float y) {
    this(bat, x, y, 150, 340);
  }

  void travel(TacticalDisplay tD, Sector current, Sector destination, StarSystem currentS, StarSystem destinationS, boolean startTravel, float speed) {

    if (floor(current.distanceSector(destination.arrayID)) == 0) travelDistance = map(currentS.distanceSystem(destinationS.loc), 0, hypotenuse(228, 173), 0, 10)*10;
    else {
      //println("inRightSpot");
      travelDistance = map(current.distanceSector(destination.arrayID), 0, hypotenuse(5, 4), 10, 50)*10+map(currentS.distanceSystem(destinationS.loc), 0, hypotenuse(228, 173), 0, 10)*10;
    }

    //println(map(currentS.distanceSystem(destinationS.loc), 0, hypotenuse(228, 173), 0, 10)*10);

    if (traveledDistance < travelDistance && startTravel && isEnabled && !powerRerouted) {
      bat.power -= 1;
      traveledDistance += speed/4;
    }
    if (traveledDistance >= travelDistance && isTraveling) {
      traveledDistance = 0;
      coordinates = new PVector(destination.id, destinationS.id, 0);
      tD.currentSector = destination.arrayID;
      isTraveling = false;
    }
  }

  @Override
    void update() {
    super.update();
    if (isEnabled) segmantLight = second()%6;
    else segmantLight = -1;
    if (bat.power <= 100 && isEnabled && !powerRerouted) bat.power++;
    if (bat.power < 100 && isEnabled && powerRerouted) bat.power+=5;
  }

  @Override
    void render() {
    switch(scene) {
    case 0:
      //12 segmants
      fill(200);
      drawRect(0, 110, originalSize.x, originalSize.y-120*2+20, 50);
      fill(100);
      drawRect(0, originalSize.y/2-20, originalSize.x, 40);
      if (isEnabled && !powerRerouted) fill(255);
      else fill(150);
      drawRect(0, originalSize.y/2-10, originalSize.x, 20);
      fill(100);
      drawEllipse(originalSize.x/2, originalSize.y/2, 50, 50);
      if (isEnabled) fill(255);
      else fill(150);
      drawEllipse(originalSize.x/2, originalSize.y/2, 25, 25);
      fill(100);
      drawRect(originalSize.x/2-2.5, originalSize.y/2-15, 5, 30);
      stroke(0);
      strokeWeight(1);
      for (int i = 0; i < 6; i++) {
        if (segmantLight == i || 12-segmantLight == i) fill(#95D2FF);
        else fill(#0075CB);
        drawRect(10, 20*i, originalSize.x-20, 20, 50);
      }
      for (int i = 0; i < 6; i++) {
        if (segmantLight == i+7 || 12-segmantLight == i+7) fill(#95D2FF);
        else fill(#0075CB);
        drawRect(10, 20*i+(originalSize.y-120), originalSize.x-20, 20, 50);
      }
      break;
    case 1:
      fill(255, 0, 0);
      drawRect(0, 0, originalSize.x-5, originalSize.y);
      fill(255);
      textAlign(CENTER, CENTER);
      displayText("ERROR\nNO CORE", 0, 0, originalSize.x-5, originalSize.y);
      textAlign(RIGHT, BOTTOM);
      isEnabled = false;
      break;
    }
  }
}

class Impulse extends UIElement {
  PShape left, right;
  boolean powerSave;
  Batteries bat;

  Impulse (Batteries bat, float x, float y, float w, float h) {
    super(x, y, w, h);
    this.bat = bat;
  }

  Impulse (Batteries bat, float x, float y) {
    this(bat, x, y, 150, 50);
  }

  @Override
    void update() {
    super.update();

    x+=5;
    y+=5;
    h-=10;
    w-=10;
    if (isEnabled && !powerRerouted && !powerSave) {
      bat.power-=0.03;
      left = createShape();
      left.beginShape();
      left.fill(255, 0, 0);
      left.vertex(x, y);
      left.vertex(x, y+h);
      left.vertex(x+w/2-w/8, y+h/1.5);
      left.vertex(x+w/2-w/8, y);
      left.endShape();

      right = createShape();
      right.beginShape();
      right.fill(255, 0, 0);
      right.vertex(x+w-w/2+w/8, y);
      right.vertex(x+w, y);
      right.vertex(x+w, y+h);
      right.vertex(x+w-w/2+w/8, y+h/1.5);
      right.endShape();
    } else if (powerSave && isEnabled) {
      bat.power-=0.01;
      left = createShape();
      left.beginShape();
      left.fill(175, 0, 0);
      left.vertex(x, y);
      left.vertex(x, y+h);
      left.vertex(x+w/2-w/8, y+h/1.5);
      left.vertex(x+w/2-w/8, y);
      left.endShape();

      right = createShape();
      right.beginShape();
      right.fill(175, 0, 0);
      right.vertex(x+w-w/2+w/8, y);
      right.vertex(x+w, y);
      right.vertex(x+w, y+h);
      right.vertex(x+w-w/2+w/8, y+h/1.5);
      right.endShape();
    } else {
      left = createShape();
      left.beginShape();
      left.fill(100, 0, 0);
      left.vertex(x, y);
      left.vertex(x, y+h);
      left.vertex(x+w/2-w/8, y+h/1.5);
      left.vertex(x+w/2-w/8, y);
      left.endShape();

      right = createShape();
      right.beginShape();
      right.fill(100, 0, 0);
      right.vertex(x+w-w/2+w/8, y);
      right.vertex(x+w, y);
      right.vertex(x+w, y+h);
      right.vertex(x+w-w/2+w/8, y+h/1.5);
      right.endShape();
    }
    if (isEnabled && powerRerouted) bat.power+=0.01;
    x-=5;
    y-=5;
    h+=10;
    w+=10;
  }

  @Override
    void render() {
    noStroke();
    fill(200);
    drawRect(0, 0, originalSize.x, originalSize.y, 10);
    shape(left);
    shape(right);
    if (isEnabled) {
      fill(0);
      textAlign(CENTER, BOTTOM);
      textSize(map(10, 0, 1600, 0, width+height));
      if (powerRerouted) displayText("Power Rerouted", 0, 0, originalSize.x, originalSize.y);
      else if (powerSave) displayText("Powersave Active", 0, 0, originalSize.x, originalSize.y);
    }
  }
}
