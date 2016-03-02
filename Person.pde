import gifAnimation.*;

//const STATE_MERGE = 1;
//`const STATE_FOLLOW = 2;
int SMOOTH_READINGS = 20;

class Person {

  int NUM_GIFS = 2;

  long count = 0;
  Character[] arrCharacters = new Character[NUM_GIFS];
  int characterIndex = 0;
  int index = 0;
  float MAG = 0;
  int totalLiveCharacters = 0;

  float[] smooth_readings = new float[SMOOTH_READINGS];
  int smooth_index = 0;
  float smooth_total = 0;
  
  PApplet parent;
  
  Person (PApplet _parent, int _index) {
   
     count = 0;
     index = _index;
     parent = _parent;
     smooth_total = 0;
  }

  void clear() {
    count = 0;
    characterIndex = 0;
  }


  void addGif(KJoint[] joints, int _index) {
  
    boolean bFlipped = false;

    int originX = 0;
    int originY = (int)joints[KinectPV2.JointType_AnkleRight].getY();

    float _r = random(0,1);
    //println(_r);

    if (_index < NUM_GIFS)
    { 
      
      if (_index % 2 == 1) {

        //println("FLIPPED");
        bFlipped = true;
        originX = width;
      }
   
      //println("NDI : " + newDancerIndex);
      
      arrCharacters[_index] = new Character(parent, originX, originY, arrGif[newDancerIndex], bFlipped);
      
      //INCREMENT THE MASTER NEW DANCER INDEX
      newDancerIndex++;
      if (newDancerIndex >= arrGif.length) {
        newDancerIndex = 0;
      }

    }
  }
  
  
  PVector getOrigin(KJoint[] joints, float _skeletonAdjustX, float _skeletonAdjustY, int _leftOffset)
  {

    int _y = int(Math.max(joints[KinectPV2.JointType_AnkleLeft].getY(), joints[KinectPV2.JointType_AnkleRight].getY()));
    
    PVector _v = new PVector(joints[KinectPV2.JointType_SpineBase].getX()*_skeletonAdjustX - _leftOffset,_y*_skeletonAdjustY);
    //PVector _v = new PVector(joints[KinectPV2.JointType_SpineBase].getX(), _y);
     
    return _v;
  }
  
  
  void draw(KJoint[] joints, float skeletonAdjustX, float skeletonAdjustY, int leftOffset) {
    
    int _x = 0;
    int _y = 0;
    PVector _origin;

    float _scale = smoothTotal() * skeletonAdjustY;
    count++;

    _origin = getOrigin(joints, skeletonAdjustX, skeletonAdjustY, leftOffset);
    
    if (count > 50 && characterIndex < NUM_GIFS) {
      addGif(joints, characterIndex);
      characterIndex++;
      count = 150;
    }

   //println("ORIGIN " + _origin.x + " " + _origin.y);
   //println("");
 
    print("c>" + characterIndex + ">" + _scale + ">" + smoothTotal() + ">" + skeletonAdjustY);


    for (int i=0; i<characterIndex; i++)
    {
      /*
      if (arrCharacters[i].state == GIF_STATE_WAIT)
      {
        if (arrCharacters[i].count > 100)
        {
          addGif(joints, i);
        }
      }
      else
      {
        */
            
        //int _y = int(Math.max(joints[KinectPV2.JointType_AnkleLeft].getY(), joints[KinectPV2.JointType_AnkleRight].getY()));
        //PVector _v = new PVector(joints[KinectPV2.JointType_SpineBase].getX()*_skeletonAdjustX - _leftOffset,_y*_skeletonAdjustY);
    
    print("s>" + arrCharacters[i].state);
        
       if (arrCharacters[i].state == GIF_STATE_SHOULDER || arrCharacters[i].state == GIF_STATE_DANCE_SHOULDER) { // || arrCharacters[i].state == GIF_STATE_STUCK) {
                     
          //_x = int(joints[KinectPV2.JointType_ShoulderRight].getX() + 30*_scale);
          //_y = int(joints[KinectPV2.JointType_ShoulderRight].getY() - 30*_scale);
          
          _y = int(joints[KinectPV2.JointType_ShoulderRight].getY()*skeletonAdjustY - 30*_scale);
          _x = int(joints[KinectPV2.JointType_ShoulderRight].getX()*skeletonAdjustX - leftOffset + 30*_scale);
    
          //arrCharacters[i].state = GIF_STATE_FLOAT;
          
        } else {
          
          int _offset = int(-165 * _scale);
          
          if (arrCharacters[i].isRight) {
            _offset = int(165 * _scale);
          }
          
          _x = int(_origin.x + _offset);
          _y = int(_origin.y + 40 * _scale);
   
       }
        
        print(">" + _x + ">" + _y);
        
        /*
        if (arrCharacters[i].isRight) {
        
          if (arrCharacters[i].state == GIF_STATE_SHOULDER || arrCharacters[i].state == GIF_STATE_STUCK) { //arrCharacters[i].isMove) {
          
          _x = int(joints[KinectPV2.JointType_ShoulderRight].getX() + 30*_scale);
          _y = int(joints[KinectPV2.JointType_ShoulderRight].getY() - 30*_scale);
          } else {
          
          _x = int(_origin.x + 165 * _scale);
          _y = int(_origin.y + 40 * _scale);
          }
        } else {
        
          if (arrCharacters[i].state == GIF_STATE_SHOULDER || arrCharacters[i].state == GIF_STATE_STUCK) { //arrCharacters[i].isMove) {
          
          _x = int(joints[KinectPV2.JointType_ShoulderRight].getX() + 30*_scale);
          _y = int(joints[KinectPV2.JointType_ShoulderRight].getY() - 30*_scale);
          } else {
          
          _x = int(_origin.x - 165 * _scale);
          _y = int(_origin.y + 40 * _scale);
          }
        }
       */

      if (!arrCharacters[i].draw(_x, _y, _scale))
      {
          print(">nd");
          
          arrCharacters[i].swapGif(parent, arrGif[newDancerIndex]);
        
          //INCREMENT THE MASTER NEW DANCER INDEX
          newDancerIndex++;
          if (newDancerIndex >= arrGif.length) {
            newDancerIndex = 0;
          }
      
      }   
    }

    fill(255,255,0);

    //println("ORIGIN " + _origin.x + " " + _origin.y);
    //ellipse(_origin.x,_origin.y-100,10,10);      
  }

  float smoothTotal()
  {
    return smooth_total;
  }
  
  float smoothVal(float _val)
  {
    smooth_total = _val;
    return _val;
  }
  
  /*
  float smoothTotal()
  {
    return smooth_total / SMOOTH_READINGS;
  }
  
  float smoothVal(float _val)
  {
  smooth_total = smooth_total - smooth_readings[smooth_index];
  
  // read from the sensor:  
  smooth_readings[smooth_index] = _val; 

  // add the reading to the total:
  smooth_total = smooth_total + smooth_readings[smooth_index];       

  // advance to the next position in the array:  
  smooth_index = smooth_index + 1;                    

  // if we're at the end of the array...
  if (smooth_index >= SMOOTH_READINGS)              
    // ...wrap around to the beginning: 
    smooth_index = 0;                           

  // calculate the average:
  return smooth_total / SMOOTH_READINGS;
  }
  */
  
}

