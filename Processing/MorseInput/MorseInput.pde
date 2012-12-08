import processing.serial.*;
import rita.*;
import controlP5.*;

import org.apache.commons.httpclient.cookie.*;
import org.apache.commons.httpclient.util.*;
import org.apache.commons.httpclient.protocol.*;
import org.apache.commons.httpclient.params.*;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.multipart.*;
import org.apache.commons.httpclient.methods.*;
import org.apache.commons.httpclient.auth.*;


// Config /////////////////////////////////////////////////////////
   
    int DIT_LOW      = 540;
    int DIT_HIGH     = 560;
    int DAH_LOW      = 620;
    int DAH_HIGH     = 640;
    int PAUSE_LENGTH = 90;
    int GAP_LENGTH   = 180;
boolean DEV_MODE     = false;
boolean PRES_MODE    = false;
boolean GENIUS_MODE  = false;
boolean DOUBLE_CHECK = true;
 String POST_URL     = "http://birdwire.herokuapp.com/tweet";
 
 
// Globals ////////////////////////////////////////////////////////
 
     Serial myPort;
Interpreter enigma;
 HttpClient c;
  ControlP5 cp;
      Range ditRange, dahRange;
     String tweet; 
     PImage logo;
     PShape house;
      PFont font;


// Setup //////////////////////////////////////////////////////////

void setup() {
  
  size(525,205);
  //frameRate(2);
  smooth();
  background(0,190,240);
  frame.setBackground(new java.awt.Color(0,190,240));
  
  String[] slist = Serial.list();
  if(DEV_MODE){
    println(slist);
    POST_URL = "http://localhost:5000/tweet";
  }
  if(slist.length >= 5) {
    String portName = Serial.list()[4];
    myPort = new Serial(this, portName, 9600);
  }
  
  enigma = new Interpreter(PAUSE_LENGTH, GAP_LENGTH);
  enigma.lex = new RiLexicon(this);
  
  c = new HttpClient();
  
  logo = loadImage("logo_inverted.png");
  
  // Use a font of your choosing here
  font = loadFont("Avenir-Roman-12.vlw");
  
  house = loadShape("birdhouse.svg");
  textFont(font);
  emptyTweet();
  
  setupControlPanel();

}


// Animation Loop /////////////////////////////////////////////////

void draw() {
  
  background(0,190,240);
  enigma.tick();
  
  drawAntenna();
  drawContainer();
  
}


// Input //////////////////////////////////////////////////////////

void keyPressed() {
  
  if(keyCode == 46){
    enigma.feedInput("1");
  }
  else if(keyCode == 32) {
    enigma.feedInput("2"); 
  }
  
}

void serialEvent(Serial myPort) {
  int peck = myPort.read();
  enigma.feedInput("" + peck);
}


// Sharing ////////////////////////////////////////////////////////

void postTweet() {
  
  try {

    PostMethod post = new PostMethod(POST_URL);
    post.addParameter("tweet", tweet.substring(0,139));
    
    // In order to send a tweet to the @birdwire account you need to send 
    // a password as a parameter in your POST request.
    // Feel free to ask for it :>

    post.addParameter("pw", "");
  
    c.executeMethod(post);
    String response = post.getResponseBodyAsString();
    println(response);
    post.releaseConnection();
    emptyTweet();
  
  } catch (Exception e) { e.printStackTrace(); }
  
}

void emptyTweet() {
  tweet = (DEV_MODE) ? "TEST " : "";
  tweet = (PRES_MODE) ? "This is a live tweet from BBG 213: " : tweet;
}

