float px = 0;     // point position (set by mouse)
float py = 0;

float x1 = 100;   // line defined by two points
float y1 = 300;
float x2 = 500;
float y2 = 100;


void setup() {
  size(600,400);
  //noCursor();

  strokeWeight(6);  // make things a little easier to see
}

void draw(){
  background(255);
  
  px = mouseX;
  py = mouseY;
  
  //check for collision
  //if hit change line colour
  boolean hit = linePoint(x1,y1, x2,y2, px,py);
  if (hit) stroke(255,150,0,150);
  else stroke(0,150,255,150);
  line(x1,y1, x2,y2);
  
  //draw point
  stroke(0,150);
  //point(px,py);
}

//line point
boolean linePoint(float x1, float y1, float x2, float y2, float px, float py){
  //distance between the point and the two ends of the line
  float d1 = dist(px,py, x1,y1);
  float d2 = dist(px,py, x2,y2);
  
  //dist finds length of line though pythagoras
  float lineLen = dist(x1, y1, x2, y2); 
  
  //since floats are very accurate, the collision only occurs if the point is exactly on the line
  // we need a buffer
  
  float buffer = 0.1; //higher number, less acurate collision
  
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer){
  return true;
  }
  return false;
}




// if d1+d2 is equal to the length of the line, we are on the line
