//https://forum.processing.org/one/topic/vertical-text.html 
void setup() 
{
  size(300,300);
  smooth();
}

void draw()
{
  background(255);
  fill(80);

  float x = 30;
  float y = 150;
  textAlign(CENTER,BOTTOM);

  pushMatrix();
  translate(x,y);
  rotate(-HALF_PI);
  text("Some vertical text",0,0);
  popMatrix();
}
