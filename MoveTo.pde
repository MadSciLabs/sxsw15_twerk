/**
 * Acceleration with Vectors 
 * by Daniel Shiffman.  
 * 
 * Demonstration of the basics of motion with vector.
 * A "Mover" object stores location, velocity, and acceleration as vectors
 * The motion is controlled by affecting the acceleration (in this case towards the mouse)
 */


class MoveTo {

  // The Mover tracks location, velocity, and acceleration 
  PVector location;
  PVector velocity;
  //PVector acceleration;

  // The Mover's maximum speed
  float topspeed_float;
  float topspeed_dance;
  float currSpeed;

  MoveTo(int _x, int _y) {

    // Start in the center
    location = new PVector(_x,_y);
    velocity = new PVector(0,0);

    topspeed_float = 15;
    topspeed_dance = 5;
    currSpeed = topspeed_dance;
  }
  
  void dance(int _targetx, int _targety) {
    
    // Compute a vector that points from location to mouse
    PVector target = new PVector(_targetx, _targety);
    PVector acceleration = PVector.sub(target,location);

    // Set magnitude of acceleration
    acceleration.setMag(.2);
    
    // Velocity changes according to acceleration
    //velocity.add(acceleration);

    velocity.add(acceleration);
      
    // Limit the velocity by topspeed
    velocity.limit(topspeed_dance);
 
    // Location changes by velocity
    location.add(velocity);
  }

  boolean set(int _targetx, int _targety)
  {
    location.x = _targetx;
    location.y = _targety;
    
    return true;
  }
 
  boolean update(int _targetx, int _targety, int _maxSpeed) {
    
    // Compute a vector that points from location to mouse
    //PVector mouse = new PVector(mouseX,mouseY);
    //PVector acceleration = PVector.sub(mouse,location);
    PVector target = new PVector(_targetx, _targety);
  
    // Set magnitude of acceleration
    //acceleration.setMag(-.2);
    
    // Velocity changes according to acceleration
    //velocity.add(acceleration);

    velocity = PVector.sub(target,location);

    //Get difference in vector locations
    float d = location.dist(target);
    //println(velocity.mag());
    
    currSpeed = _maxSpeed;
    if (.2*d < _maxSpeed) {
      currSpeed = .2*d;
    }
      
    // Limit the velocity by topspeed
    velocity.limit(currSpeed);
 
    // Location changes by velocity
    location.add(velocity);
    
    //If we have reached des
    if (d < 5) {
      return true;
    } else {
       return false; 
    }
  }

  void display() {
    stroke(255);
    strokeWeight(2);
    fill(127);
    ellipse(location.x,location.y,48,48);
  }

}

