import java.util.Map;
import java.util.Iterator;

//sound library minim
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import SimpleOpenNI.*;


//kinect library
SimpleOpenNI context;
int handVecListSize = 20;
Map<Integer,ArrayList<PVector>>  handPathList = new HashMap<Integer,ArrayList<PVector>>();
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
          
                                   
                                   
                                   
//gloable variables. 
Minim minim;
AudioPlayer song;
AudioPlayer song1;
AudioPlayer song3;
BeatDetect beat;
BeatDetect beat1;
BeatDetect beat3;
AudioMetaData meta;
AudioMetaData meta1;
AudioMetaData meta3;

boolean selectmusic = false; 
int randomSong = 1; 
PImage foto; 

float eRadius;
float t; 

float y = 350;
float xy = 2;

float X = 650;
float dx = 2;

float s = 350;
float sx = 2;

float x1(float t){
  return sin(t / 10) * 200 + sin (t / 5 ) * 20;
}

float y1(float t){
  return cos(t / 10) * 200;
}

float x2(float t){
  return sin(t / 10) * 400 + sin (t) * 2;
}

float y2(float t){
  return cos(t / 20) * 400 + cos (t / 12) * 20;
}

float x = 0;


static final int NUM_LINES = 20;

void setup()
{
  size(1000, 1000, P3D);
  minim = new Minim(this);
    
  foto = loadImage("linkin.png");
  
  //inladen van muziek files
  song = minim.loadFile("Ten.mp3");
  song1 = minim.loadFile("Wavy.mp3");
  song3 = minim.loadFile("numb.mp3");
 
  
  beat = new BeatDetect();
  beat1 = new BeatDetect();
  beat3 = new BeatDetect();
  
  
  meta = song.getMetaData();
  meta1 = song1.getMetaData();
  meta1 = song3.getMetaData();
  
  //kinect conectie
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }   
  
  

  // enable depthMap generation 
  context.enableDepth();
  
  // disable mirror
  context.setMirror(true);

  // enable hands + gesture generation
  context.enableHand();
  context.startGesture(SimpleOpenNI.GESTURE_WAVE);
  context.startGesture(SimpleOpenNI.GESTURE_CLICK);
  

}

void draw()
{
  
  background(0);
  beat.detect(song.mix);
  strokeWeight(5); 
  
  
   //update camera
  context.update();
   
 //inladen functies voor liedje + vorm  
   if (randomSong == 1 ){
     nummer1();
   } else if (randomSong == 2){
     nummer2();
   } else if (randomSong == 3){
     nummer3();
   }
   
   

      
}

//eerste liedje met daarbij behorende vorm.
void nummer1() {
  
  //als een ander liedje aan het spelen is word deze op pause gezet. 
    if (song1.isPlaying())
  {
      song1.pause();
  } else if (song3.isPlaying())
  {
    song3.pause();
  }
  
  song.play();
  
  
  //als er een beat gevonden word veranderd de vorm 
    if(beat.isOnset() ){
    eRadius = 80; 
    strokeWeight(25);
    }
    
    
  float a = map(eRadius, 20, 80, 60, 255);
  stroke(60, 255, 0, a);

   eRadius *= 0.95;
   if ( eRadius < 20 ) eRadius = 20;
   
   translate(width/2, height/2);
   
  //aanmaken van de lijnen die loopen in bepaalde vorm 
   for (int i = 0; i < NUM_LINES; i++) {
   line(x1(t + i), y1(t + i ), x2(t + i ), y2(t + i ));
   }
   
   t += 0.5;
   
}




//tweede liedje met daarbij bijhorende vorm.
void nummer2() {
  
 //als een ander liedje aan het spelen is word deze op pause gezet. 
    if (song.isPlaying())
  {
      song.pause();
  } else if (song3.isPlaying())
  {
    song3.pause();
  }
  
  
  beat1.detect(song1.mix);
  song1.play();
  
  float a = map(eRadius, 20, 80, 60, 255);
  
  
  //formule voor de beweging van de circles.
  y = y + xy;
  X = X + dx; 
  s = s + sx;
 
     
  if ( y > 650 ) {
        xy = -2; 
  }

  if ( y < 350 ) {
     xy = 2; 
  }
  
       
  if ( X > 650 ) {
        dx = -2; 
  }

  if ( X < 350 ) {
     dx = 2; 
  }
  
  if ( s > 650 ) {
        sx = -2; 
  }

  if ( s < 350 ) {
     sx = 2; 
  }
    
    
 //als beat gevonden word veranderd de vorm.
  if(beat1.isOnset() ){
    eRadius = 100; 
    strokeWeight(25);
    }
    
   eRadius *= 0.95;
   if ( eRadius < 20 ) eRadius = 20;
    
    
    ellipseMode(CENTER);
    strokeWeight(10);
    stroke(104, 237, 192, a);
    fill(0,0,0,0);
    ellipse(500,y,500,500);  //bovenste circle
     
     
    strokeWeight(10);
    stroke(104, 237, 192, a);
    fill(0,0,0,0);
    ellipse(X,600,500,500);  //rechtse circle
    
    strokeWeight(10);
    stroke(104, 237, 192 , a);
    fill(0,0,0,0);
    ellipse(s,600,500,500);  //linkse circle
}


//derde liedje met daarbij bijbehorende vorm.
void nummer3(){ 
 
 //als een ander liedje aan het spelen is word deze op pause gezet. 
    if (song1.isPlaying())
  {
      song1.pause();
  } else if (song.isPlaying())
  {
    song.pause();
  }
  
  
   
  image(foto, 150, 150);
  beat3.detect(song3.mix);
 
     if (song.isPlaying())
  {
      song.pause();
  }
  
  
  song3.play();
  
  //als beat gevonden is verander kleur van image
  if (beat3.isOnset()){
    eRadius = 80; 
    tint(161, 33, 36); // rode kleur
  }
  
     eRadius *= 0.95;
   if ( eRadius < 20 ) eRadius = 20;
   
  
  if (eRadius < 50 ){
     tint(255,255,255); // witte kleur
  }
  
}

//aanroepen volgende liedje
void nextSong() {

  float randomSong = (int) random(0, 2);
  
  
  if (song.isPlaying())
  {
      song.pause();
  }
  
  if (randomSong < 1) {
     nummer1();
  }
  
  if (randomSong > 1){
      nummer2();
  }
  
  if (randomSong == 2 ) {
    nummer3();
  }  
  
  song.loop();
}



//mute / pause de muziek 
void muteSong()
{
  if (song.isPlaying())
  {
    song.pause();
  } else
  {
    song.loop();
  }
}





//________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________




// hand events

void onNewHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  println("onNewHand - handId: " + handId + ", pos: " + pos);
 
  ArrayList<PVector> vecList = new ArrayList<PVector>();
  vecList.add(pos);
  
  handPathList.put(handId,vecList);
}

void onTrackedHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  //println("onTrackedHand - handId: " + handId + ", pos: " + pos );
  
  ArrayList<PVector> vecList = handPathList.get(handId);
  if(vecList != null)
  {
    vecList.add(0,pos);
    if(vecList.size() >= handVecListSize)
      // remove the last point 
      vecList.remove(vecList.size()-1); 
  }  
}

void onLostHand(SimpleOpenNI curContext,int handId)
{
  println("onLostHand - handId: " + handId);
  handPathList.remove(handId);
}

// -----------------------------------------------------------------
// gesture events

void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  
  int handId = context.startTrackingHand(pos);
  println("hand stracked: " + handId);
  
  //gestureType 0 = zwaaien. 
  if (gestureType == 0) {
    
         randomSong++; 
         
         if (randomSong > 3)
         {
           randomSong = 1; 
         }
      }
      
       if (gestureType == 1) {
        muteSong();
      }
  }
