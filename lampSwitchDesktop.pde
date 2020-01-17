import processing.serial.*;
Serial myPort;
boolean power;
boolean hasTTL;
color currentColor;
String state;
String waittext;
int inByte = -1;    // Incoming serial data
void setup() {
  size(500, 800);
  power = false;
  hasTTL=false;
  state = "off";
  waittext="No Device";
  currentColor = color(10, 10, 10);
  PFont myFont = createFont(PFont.list()[2], 80);
  //PFont myFontcreateFont("SourceCodePro-Regular.ttf", 80);
  textFont(myFont);
}
void draw() {
  background(currentColor);

  if (Serial.list().length==0 && !hasTTL) {
    fill(255);
    text(waittext, width/2-waittext.length()*20, height/2);
  }

  if (Serial.list().length==0 && hasTTL) {
    myPort = null;
    hasTTL=false;
    currentColor = color(10, 10, 10);
  }

  if (Serial.list().length==1 && !hasTTL) {
    String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
    hasTTL=true;
  }

  if (Serial.list().length==1 && hasTTL) {
    fill(255);
    rect(width/4, height/4, width/2, height/2);
    //ellipse(circleX, circleY, circleSize, circleSize);
    fill(0, 0, 0);
    text(state, width/2-state.length()*20, height/2);
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (hasTTL) {
    power=!power;
    if ( overRect(width/4, height/4, width/2, height/2)) {
      if (power) {
        currentColor = color(255, 255, 255);
        state = "on";
      } else {
        currentColor = color(10, 10, 10);
        state = "off";
      }
    }
  }
}

void serialEvent(Serial myPort) {
  inByte = myPort.read();
}
