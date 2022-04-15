class Timer {
  int time = 0, startingTime;
  Timer(int time) {
    startingTime = time;
  }
  
  void resetTime(int time){
    this.time = 0;
    startingTime = time;
  }
  
  void resetTimer(){
    time = 0;
  }
  
  float getTime(boolean countDown) {
    if (countDown) return round(startingTime - time/frameRate);
    return floor(time/frameRate);
  }
  
  boolean countTimer(){
    time++;
    return floor(time/frameRate) >= startingTime+1;
  }
}
