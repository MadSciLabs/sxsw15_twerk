import gifAnimation.*;

int GIF_STATE_FLOAT = 1;
int GIF_STATE_DANCE = 2;
int GIF_STATE_SHOULDER = 3;
int GIF_STATE_DANCE_SHOULDER = 4;
int GIF_STATE_LEAVE = 5;
int GIF_STATE_WAIT = 6;

int TOPSPEED_FLOAT = 20;
int WAIT_TIME = 50; //100;
int DANCE_TIME = 200; //400;



class GifSource {

  int offsetX, offsetY;
  float scale;
  String path;
  boolean inverted;
  boolean shoulder;
  
  
  GifSource(int _x, int _y, String _path, boolean _inverted, boolean _shoulder, float _scale) {

    offsetX = _x;
    offsetY = _y;
    
    //bodyOffX = _x;
    //bodyOffY = _y;
    path = _path;

    inverted = _inverted;
    
    shoulder = _shoulder;
    
    scale = _scale;
  }
}


class Character { 

  int x, y, w, h;
  //int destX, destY;

  int offsetX, offsetY; 
  int flipOffsetX;

  int skeletonIndex;
  MoveTo target;
  
  int position;
  boolean stuck = false;

  boolean origIsFlipped = false;
  boolean isFlipped = false;
  boolean isRight = false;
  boolean isMove = false;
  
  int randomX;
  int randomY;

  Gif gif;
  
  int state;
  int count;
  
  int TOPSPEED_DANCE = int(random(5,10));
  
  int flip_count = 0;
  
  int rotate = 0;

  float scale = 1;
  PFont font;


  Character(PApplet parent, int _x, int _y, GifSource _gs, boolean _flipped) {
  
    println("New Character : " + _gs.path);
    
    offsetX = _gs.offsetX;
    offsetY = _gs.offsetY;
    scale = _gs.scale;

    target = new MoveTo(_x, _y);
    gif = new Gif(parent, dataPath(_gs.path));
    gif.loop();

    w = gif.width;
    h = gif.height;
    flipOffsetX = w - offsetX;
    
    origIsFlipped = _flipped;
    isFlipped = _flipped;
    isRight = _flipped;

    randomX = 0; //int(random(-75,75));
    randomY = 0; //int(random(-10,10));
    
    count = 0;
  
    if (_gs.shoulder) {
      isMove = true;
    }

    if (_gs.inverted) {

       isFlipped = !isFlipped; 
    }
    
    state = GIF_STATE_FLOAT;
    //font = loadFont("CasaleTwo-Alternates-NBP-100.vlw");
  }

  void swapGif(PApplet parent, GifSource _gs)
  {
    offsetX = _gs.offsetX;
    offsetY = _gs.offsetY;
    scale = _gs.scale;
    
    gif = new Gif(parent, _gs.path);
    gif.loop();
    
    w = gif.width;
    h = gif.height;
    
   if (_gs.shoulder) {
      isMove = true;
    } else {
      isMove = false;
    }

    isFlipped = origIsFlipped;

    if (_gs.inverted) {
       isFlipped = !isFlipped; 
    }
    
  }
  

  boolean draw(int _x, int _y, float _scale) {
  
    count++;
 
    //Update
    if (state == GIF_STATE_SHOULDER)
    {
      if (target.update(_x, _y, TOPSPEED_FLOAT))
      {
        state = GIF_STATE_DANCE_SHOULDER; 
        //println("DANCE NOW");
        count = 0;
        //flip_count = 750;
      }
    }
    else if (state == GIF_STATE_FLOAT)
    {
      if (target.update(_x, _y, TOPSPEED_FLOAT))
      {
        state = GIF_STATE_DANCE; 
        //println("DANCE NOW");
        count = 0;
        //flip_count = 750;
      }
    }
    else if (state == GIF_STATE_LEAVE)
    {
      int _target = -500;
      if (isRight) {
        _target = width + 500;
      }
      
      if (target.update(_target, _y, TOPSPEED_FLOAT))
      {
        state = GIF_STATE_WAIT; 
        count = 0;
        
        return false;
      }

    }
    else if (state == GIF_STATE_WAIT)
    {

      if (count > WAIT_TIME) {
            
        state = GIF_STATE_FLOAT;
        count = 0;
      }
    }
    else
    {
 
      target.update(_x, _y, TOPSPEED_DANCE);
      
      //if (isMove == true && count > flip_count) {
      //  state = GIF_STATE_SHOULDER;
      //}

      if (count > DANCE_TIME) {
         
         if (isMove == true && state == GIF_STATE_DANCE) {
           state = GIF_STATE_SHOULDER;
         } else {
           state = GIF_STATE_LEAVE;
         }
      }
        
    }
    
    //if (count > 1000 && isMove)
    pushMatrix();
    if (isFlipped) {
    
      //flip across x axis
      translate(target.location.x, target.location.y);

      scale(-1,1);
      scale(_scale * scale);
      //rotateThis();
      //image(gif,-flipOffsetX, -offsetY);
      image(gif,-offsetX, -offsetY);
      
    } else {
  
      translate(target.location.x, target.location.y);
      scale(_scale * scale);
      //translate(target.location.x-offsetX, target.location.y-offsetY);
      //rotateThis();
      image(gif, -offsetX, -offsetY);
    }
    
    popMatrix();
    
    /*
    noFill();
    stroke(255,0,0);
    textFont (font,30);
    textAlign(CENTER);
    text("State : " + state,target.location.x,target.location.y+30);
    */
    return true;

  }
  
  void rotateThis()
  {
    if (state == GIF_STATE_SHOULDER) {
      rotate =  rotate+10;
      rotate(radians(rotate));
    }
  }

}
