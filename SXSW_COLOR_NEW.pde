/*
Copyright (C) 2014  Thomas Sanchez Lengeling.
 KinectPV2, Kinect for Windows v2 library for processing
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import KinectPV2.KJoint;
import KinectPV2.*;
import gab.opencv.*;
//powerlite 703c

///////////////////
//STATE
//////////////
final int STATE_BACKGROUND = 0;
final int STATE_VIDEO = 1;

int NUM_STATES = 2;
int MAX_PLAYERS = 5;

int currentState = 1;

boolean FULL_SCREEN = true;
boolean AUTO_MOVE = true;
boolean DEBUG = false;
String DEBUG_STRING = "";
boolean COLOR = false;

int screenWidth = 1920;
int screenHeight = 1080;

int FULLVIDEO_WIDTH = 1920;
int FULLVIDEO_HEIGHT = 1080;

int ROTATE_SPEED = 20;

float t_Dist = 0;
float t_Size = 0;

PFont font;
 
timer stateTimer = new timer(ROTATE_SPEED);

//////////////////////////
//BACKGROUND
/////////////////////////
OpenCV opencv;
Gif[] arrBackgroundGif = new Gif[7]; //int gifIndex = 0;

String[] sBackgroundPath = {
  "glitch1.gif",
  "glitch2.gif",
  "glitch_a.gif",
  "glitch_b.gif",
  "glitch_c.gif",
  "glitch_d.gif",
  "glitch_e.gif"
};

int backgroundGifIndex = 0;

//INIT BACKGROUND
int backgroundWidth = (screenHeight * 512) / 424;  
int backgroundHeight = screenHeight;

int backgroundLeftOffset = (screenWidth - backgroundWidth)/2;

int adjustedScreenWidth =  (screenHeight * 1920) / 1080;
int adjustedScreenHeight = screenHeight;

int adjustedScreenLeftOffset = (adjustedScreenWidth - screenWidth)/2;

float skeletonAdjustedHeight = float(adjustedScreenHeight) / FULLVIDEO_HEIGHT;
float skeletonAdjustedWidth = skeletonAdjustedHeight; //float(screenWidth) / FULLVIDEO_WIDTH;

//////////////////////////////
//DANCING
/////////////////
float zVal = 300;
float rotX = PI;

//boolean isTracked = false;
int guyx = 0;
int guyy = 0;

int guyx_left = -200;
int guyx_right = 2000;

int NUM_GIFS = 30;
int characterIndex = 0;

PImage[] animation;

//boolean showSkeleton = true;
boolean showBackground = true;

int newDancerIndex = 0;

PImage pimg;

GifSource[] arrGif = {

  //new GifSource(0,0,"cop.gif"), 
  new GifSource(120,800,"lady.gif",false, false,.7), 
  new GifSource(145,800,"eggplant.gif",false, false,.7), 
  new GifSource(100,550,"twerky.gif", true, false,1),
  //new GifSource(220,300,"heaven_220_400.gif", false, false,.5),
  
  new GifSource(135,800,"100.gif",false, false,.7), 
  new GifSource(165,800,"nudes.gif",false, false,.7), 
  new GifSource(125,800,"money.gif",false, false,.7), 
  new GifSource(30,500,"alfonso.gif", true, false,1),
  
  new GifSource(100,500,"g_1.gif",false, false,1), 
  new GifSource(250,580,"giphy.gif",false, false,1), 
  new GifSource(100,500,"g_2.gif",false, false,1), 
 
   new GifSource(250,435,"guygal.gif",true, false,1),
  new GifSource(100,230,"tumblr.gif",true, true,1),
  new GifSource(100,400,"g_4.gif",false, false,1), 
  
   new GifSource(100,200,"g_5.gif",false, false,1), 
  //new GifSource(80,106,"pokemon_80_106.gif", true, false,1),
  new GifSource(200,455,"gameboy.gif", true, false,.5),
  new GifSource(200,270,"lisa.gif", true, false,1),
  new GifSource(250,580,"giphy.gif",false, false,1), 
   new GifSource(160,500,"g_3.gif",false, false,.75), 
  //new GifSource(250,490,"dino_250_490.gif", true, false,1),
  new GifSource(90,350,"hammer_90_350.gif", false, false,1),
  //new GifSource(250,450,"ironman_250_450.gif", true, false,1),
  //new GifSource(105,320,"link_105_320.gif", false, false,1),
  new GifSource(250,450,"powerguy_250_450.gif", false, false,1)
  //new GifSource(310,300,"showme_310_500.gif", false, false,.5)
};

Character[] arrCharacters = new Character[NUM_GIFS];
Person[] arrPerson = new Person[6];

KinectPV2 kinect;

boolean bDrawSkeleton = false;

Skeleton [] skeleton;
Skeleton [] skeleton3d;

//ArrayList<layerPiece> arrLayerOrder = new ArrayList<layerPiece>();
layerPiece[] arrLayerOrder = new layerPiece[6];


void setup() {

  println(dataPath("giphy.gif"));
  size(screenWidth,screenHeight);

  kinect = new KinectPV2(this);
  kinect.enableSkeleton(true);
  kinect.enableSkeletonColorMap(true);

  kinect.enableCoordinateMapperRGBDepth(true);
  
  //kinect.enableSkeleton3dMap(true);

  //kinect.enableColorImg(true);
  //kinect.enableBodyTrackImg(true);  
  
  kinect.init();
  
  opencv = new OpenCV(this,512,424);

  //INIT PEOPLE
  for (int i=0; i<6; i++)
  {
        arrPerson[i] = new Person(this, i);
  }

  
  for (int i=0; i < sBackgroundPath.length; i++)
  {
     arrBackgroundGif[i] = new Gif(this, dataPath(sBackgroundPath[i]));
     arrBackgroundGif[i].loop();
  }

  if (DEBUG)
  {
    font = loadFont(dataPath("CasaleTwo-Alternates-NBP-100.vlw"));
  }
  
  //SETUP A BACKGROUND IMAGE
  PImage img = loadImage("bg.png");
  img.loadPixels();
  kinect.setCoordBkgImg(img.pixels);
  
  for (int i=0; i<arrLayerOrder.length; i++)
  {
    arrLayerOrder[i] = new layerPiece(0,0);
  }
  
}

boolean sketchFullScreen() {
  return FULL_SCREEN;
}


void draw() {

  noCursor();
  //background(0);

  //AUTO MOVE
  if (AUTO_MOVE) {
    
    if (stateTimer.isTime()) {
      advanceState();
    }
  }
  
  debugAdd("AUTO : " + AUTO_MOVE);
  
  debugAdd("SCREEN : " + screenWidth + " "+ screenHeight);
  debugAdd("ADJUSTED SCREEN : " + adjustedScreenWidth + " "+ adjustedScreenHeight);
  debugAdd("LEFT OFFSET : " + adjustedScreenLeftOffset);
  //debugAdd("Skeleton adjustements : " + skeletonAdjustedWidth + " " + skeletonAdjustedHeight);
  
  
  //LOOK FOR DIFFERENT STATES
  switch(currentState)
  {
    //STATE_BACKGROUND
    case STATE_BACKGROUND:
    
      drawBackground();
      break;
 
    //STATE_DANCE
    case STATE_VIDEO:
    
    
      //pimg = kinect.getColorImage();
      //pimg.filter(GRAY);
      //image(kinect.getColorImage(), 0, 0, adjustedScreenWidth - adjustedScreenLeftOffset, adjustedScreenHeight); //width, height);
      image(kinect.getCoordinateRGBDepthImage(), 0, 0, adjustedScreenWidth - adjustedScreenLeftOffset, adjustedScreenHeight);
      
      //translate(-adjustedScreenLeftOffset,0);
      //scale(skeletonAdjustedHeight,skeletonAdjustedHeight);
      //translate(-adjustedScreenLeftOffset,0);
      
      drawDancers();
  
      break;
  }
  
  //DRAW DEBUG
  debugDraw();

}

void drawBackground()
{
  translate(backgroundLeftOffset,0);
  
  //Tile the background
  for (int i=0; i<4; i++) {
    for (int j=0; j<4; j++) {
      image(arrBackgroundGif[backgroundGifIndex],
        i*arrBackgroundGif[backgroundGifIndex].width, 
        j*arrBackgroundGif[backgroundGifIndex].height
       );
    }
  }
  
  PImage _p = kinect.getBodyTrackImage();

  opencv.loadImage(_p);
  opencv.threshold(250);
  
  PImage _t = opencv.getSnapshot();
  
  //Mask out the background
  for (int i = 0; i < _t.pixels.length; i++) {
    if (_t.pixels[i] == color(0))
    {
      _t.pixels[i] = color(0,0,0,0);
    } else {
      _t.pixels[i] = color(0);
    }
  }

  _t.updatePixels();  
  opencv.loadImage(_t);

  //println("BACK " + backgroundWidth + " " + backgroundHeight);
  image(_t,0,0, backgroundWidth, backgroundHeight);
  
  noStroke();
  fill(0);
  rect(-backgroundLeftOffset,0,backgroundLeftOffset+1,height);
  rect(backgroundWidth-1,0,backgroundLeftOffset+backgroundWidth,height);
}

void drawDancers()
{
  //ArrayList<layerPiece> arrLayerOrder = new ArrayList<layerPiece>();
  //arrLayerOrder = new ArrayList<layerPiece>();

  int skeletonIndex = 0;
  float _mag;
  float _dist;
  int danceIndex = 0;
  
  //skeleton3d =  kinect.getSkeleton3d();
  skeleton = kinect.getSkeletonColorMap();

  for (int i=0; i<skeleton.length; i++)
  {
    if (skeleton[i].isTracked())
    {    
      KJoint[] joints = skeleton[i].getJoints();
     
      _dist = dist(
        joints[KinectPV2.JointType_SpineBase].getX(),
        joints[KinectPV2.JointType_SpineBase].getY(),
        joints[KinectPV2.JointType_Neck].getX(),
        joints[KinectPV2.JointType_Neck].getY()
      );


      _mag = _dist/200;
      _mag = arrPerson[i].smoothVal(_mag);
      
      int newIndex = danceIndex;
      for (int j=0; j<danceIndex; j++)
      {
        //if (_mag < arrLayerOrder.get(j).mag) {
        if (_mag < arrLayerOrder[j].mag) {  
            newIndex = j;
         }
      }
      
      //arrLayerOrder.add(newIndex,(new layerPiece(i,_mag)));
      arrLayerOrder[newIndex] = new layerPiece(i,_mag);
      //print(i);
      
     print(">" + i + ">" + newIndex + ">" + danceIndex); 
      
      danceIndex++;
    }
  }  

  //println("SIZE : " + danceIndex);

  //for (int i = 0; i < skeleton.length; i++) {
  int _numPlayers = Math.min(danceIndex, MAX_PLAYERS);

  print(">" + _numPlayers);  
  //println("PLAYERS : " +_numPlayers);


  for (int i=0; i < _numPlayers; i++) {

    //skeletonIndex = arrLayerOrder.get(i).index;
    //println(">" + i + ">" + _numPlayers);

    print("start>" + i);
    skeletonIndex = arrLayerOrder[i].index;
    print(">" + skeletonIndex);
     
    if (skeleton[skeletonIndex].isTracked()) {
      
      print(">t");
      
      KJoint[] joints = skeleton[skeletonIndex].getJoints();
      //KJoint[] joints3d = skeleton3d[skeletonIndex].getJoints();

      //color col  = getIndexColor(skeletonIndex);
      //fill(col);
      //stroke(col);

      //Draw the twerkers
      arrPerson[skeletonIndex].draw(joints,skeletonAdjustedWidth,skeletonAdjustedHeight,adjustedScreenLeftOffset);

      if (bDrawSkeleton) {

        pushMatrix();    
        scale(skeletonAdjustedHeight,skeletonAdjustedHeight);
        translate(-skeletonAdjustedHeight*adjustedScreenLeftOffset,0);
        
        drawBody(joints,false);
        
        //Draw the 3D things here
        
        popMatrix();
              
      }
   
    } else {
    
      arrPerson[skeletonIndex].clear();
    }
  }
  
  println("");
  
  //FOR 3D
  //popMatrix();
  
}

void draw3D()
{
  //image(kinect.getColorImage(), 0, 0, 320, 240);

  skeleton3d =  kinect.getSkeleton3d();

  //translate the scene to the center
 /* 
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(zVal);
  rotateX(rotX);
*/

  float t_Dist = 0; 

  for (int i = 0; i < skeleton3d.length; i++) {

    if (skeleton3d[i].isTracked()) {
 
      KJoint[] joints3d = skeleton3d[i].getJoints();

      //Draw body
      //color col  = getIndexColor(i);
      //stroke(col);
      //drawBody(joints3d,true);
 
      t_Dist = joints3d[KinectPV2.JointType_SpineBase].getZ();

    }
  }  
  
  //popMatrix();
}

//use different color for each skeleton tracked
color getIndexColor(int index) {
  color col = color(255);
  if (index == 0)
    col = color(255, 0, 0);
  if (index == 1)
    col = color(0, 255, 0);
  if (index == 2)
    col = color(0, 0, 255);
  if (index == 3)
    col = color(255, 255, 0);
  if (index == 4)
    col = color(0, 255, 255);
  if (index == 5)
    col = color(255, 0, 255);

  return col;
}

//DRAW BODY
void drawBody(KJoint[] joints, boolean draw3D) {

  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck,draw3D);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder,draw3D);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid,draw3D);

  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase,draw3D);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight,draw3D);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight,draw3D);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft,draw3D);

  // Right Arm    
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight,draw3D);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight,draw3D);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight,draw3D);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight,draw3D);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight,draw3D);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft,draw3D);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight,draw3D);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight,draw3D);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight,draw3D);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft,draw3D);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft,draw3D);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft,draw3D);
  drawJoint(joints, KinectPV2.JointType_HandTipRight,draw3D);
  drawJoint(joints, KinectPV2.JointType_FootLeft,draw3D);
  drawJoint(joints, KinectPV2.JointType_FootRight,draw3D);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft,draw3D);
  drawJoint(joints, KinectPV2.JointType_ThumbRight,draw3D);

  drawJoint(joints, KinectPV2.JointType_Head,draw3D);
}


//DRAWING FOR 3D
/*
void drawJoint3d(KJoint[] joints, int jointType) {
  strokeWeight(2.0f + joints[jointType].getZ()*8);
  point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
}

void drawBone3d(KJoint[] joints, int jointType1, int jointType2) {
  strokeWeight(2.0f + joints[jointType1].getZ()*8);
  point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}
*/

void drawJoint(KJoint[] joints, int jointType, boolean b3D) {
  
  if (b3D)
  {
    strokeWeight(2.0f + joints[jointType].getZ()*8);
    point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  }
  else
  {
    pushMatrix();
    translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
    ellipse(0, 0, 25, 25);
    popMatrix();
  }
}

void drawBone(KJoint[] joints, int jointType1, int jointType2,  boolean b3D) {

  if (b3D)
  {
    strokeWeight(2.0f + joints[jointType1].getZ()*8);
    point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  }
  else
  {
    pushMatrix();
    translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
    ellipse(0, 0, 25, 25);
    popMatrix();
    line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  }
  
}

void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}

void keyPressed() {
  
  if (key == '1') {
      
    advanceState();
      
  } else if (key == '2') {
    
    advanceBackground();

  } else if (key == '3') {
   
     bDrawSkeleton = !bDrawSkeleton; 
  } else if (key == '4') {

     FULL_SCREEN = !FULL_SCREEN;
  } else if (key == 'a') {

    AUTO_MOVE = !AUTO_MOVE;
  } else if (key == 'b') {

    COLOR = !COLOR;
  }

}

void advanceBackground() {
  
      backgroundGifIndex++;
      if (backgroundGifIndex >= arrBackgroundGif.length)
      {
        backgroundGifIndex=0;
      } 
}

void advanceState() {
  
      currentState++;
      if (currentState >= NUM_STATES)
      {
        currentState=0;
      }
      
      if (currentState == STATE_BACKGROUND) {
         advanceBackground(); 
      } else {

         for (int i=0; i < 6; i++) {
           arrPerson[i].clear();
         }

      }
}

void mouseClicked() {
  
  //addGif();

}

void debugAdd(String _debug)
{
  if (DEBUG)
  {
    DEBUG_STRING += _debug + "\n";
  }
}

void debugDraw()
{
  if (DEBUG)
  {
    translate(100,0);

    noStroke();
    fill(255,0,0);
    textFont (font,30);
    textAlign(CENTER);
    text(DEBUG_STRING,50,50);
    
    DEBUG_STRING = "";
  }

}

class timer {
  
   long start_time;
   long diff_time;
   
   timer(int _diff_time_seconds) {
     
     start_time = millis();
     diff_time = _diff_time_seconds * 1000;
   }
   
   boolean isTime ()
   {
     if (millis() - start_time > diff_time) {
      
        start_time = millis();
        return true;
     }
     
     return false;
   }
   
}

class layerPiece {

  float mag = 0;
  int index = 0;

  layerPiece(int _i, float _m)
  {
    mag = _m;
    index = _i;
  }  
}

