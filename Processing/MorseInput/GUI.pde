
void drawAntenna() {
  translate(10,0);
  image(logo,0, 15);
  noStroke();
  if(!enigma.waiting){
    if(enigma.isDah()){
      fill(255);
      ellipse(50,65,30,30);
      fill(0,190,240);
      ellipse(50,65,25,25);
    }
    fill(255);
    ellipse(50,65,20,20);
    fill(0,190,240);
    triangle(45,80,50,65,55,80);
    ellipse(50,65,15,15);
  }
  fill(255);
  ellipse(50,65,5,5);
  rect(49,65,2,120);
  drawBirdhouse();
}

void drawBirdhouse() {
  shape(house, 0, 88, 100, 120);
}

void drawContainer() {
  translate(10,0);
  fill(0,150,200);
  rect(105,17,320,70);
  triangle(100,67,105,62,105,72);
  fill(255);
  rect(105,15,320,70);
  triangle(100,65,105,60,105,70);
  fill(0);
  text(tweet,112,20,310,70);
  fill(175,245,255);
  if(enigma.spaceIndicator){
    fill(255);  
  }
  text(Integer.toString(140 - tweet.length()), 440, 75);
}

void setupControlPanel() {
  cp = new ControlP5(this);
  ditRange = cp.addRange("dit range")
   .setBroadcast(false) 
   .setPosition(105,100)
   .setSize(320,20)
   .setHandleSize(10)
   .setRange(20,1000)
   .setRangeValues(DIT_LOW, DIT_HIGH)
   .setBroadcast(true)
   .setColorForeground(color(255,255,255))
   .setColorBackground(color(255,40))  
   ;
  ditRange = cp.addRange("dah range")
   .setBroadcast(false) 
   .setPosition(105,135)
   .setSize(320,20)
   .setHandleSize(10)
   .setRange(20,1000)
   .setRangeValues(DAH_LOW, DAH_HIGH)
   .setBroadcast(true)
   .setColorForeground(color(255,255,255))
   .setColorBackground(color(255,40))  
   ;
  cp.addToggle("spellCheck")
   .setPosition(440,15)
   .setSize(50,20)
   .setValue(GENIUS_MODE)
   .setMode(ControlP5.SWITCH)
   .setColorBackground(color(255))
   ;
  cp.addSlider("pause")
     .setPosition(105,170)
     .setSize(100,20)
     .setRange(0,100)
     .setValue(80)
     .setColorForeground(color(255,255,255))
     .setColorBackground(color(255,40))  
     ;
  cp.addSlider("gap")
     .setPosition(250,170)
     .setSize(175,20)
     .setRange(0,500)
     .setValue(180)
     .setColorForeground(color(255,255,255))
     .setColorBackground(color(255,40))  
     ;
}

void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.isFrom("dit range")) {
    DIT_LOW = int(theControlEvent.getController().getArrayValue(0));
    DIT_HIGH = int(theControlEvent.getController().getArrayValue(1));
    myPort.write("A"+DIT_LOW);
    myPort.write("B"+DIT_HIGH);
//    NOISE_THRESHOLD = (DIT_LOW - 10 < 0) ? 0 : DIT_LOW - 20;
//    println("Dit range changed.");
  }
  else if(theControlEvent.isFrom("dah range")) {
    DAH_LOW = int(theControlEvent.getController().getArrayValue(0));
    DAH_HIGH = int(theControlEvent.getController().getArrayValue(1));
    myPort.write("X"+DAH_LOW);
    myPort.write("Y"+DAH_HIGH);
//    println("Dah range changed.");
  }
}

void gap(float val) {
  GAP_LENGTH = int(val);
  enigma.reConfigure(PAUSE_LENGTH, GAP_LENGTH);
}

void pause(float val) {
  PAUSE_LENGTH = int(val);
  enigma.reConfigure(PAUSE_LENGTH, GAP_LENGTH);
}

void spellCheck(boolean theFlag) {
  if(theFlag==true) {
    GENIUS_MODE = true;
    println("Spellchecker: ACTIVE");
  } else {
    GENIUS_MODE = false;
    println("Spellchecker: INACTIVE");
  }
}
