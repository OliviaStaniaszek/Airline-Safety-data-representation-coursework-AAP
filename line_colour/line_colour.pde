int[] airlines = new int[33];
float[] hue = new float[33];

void setup(){
  background(0);
  colorMode(HSB,360,100,100);
  noStroke();
  size(800,400);
  for(int i=0; i < airlines.length;i++){
    airlines[i] = i;
    hue[i] = map(airlines[i],0,32,0,340);
    println(i,hue[i]);
    fill(hue[i],int(random(50,70)),int(random(90,100))); // hue, saturation, brightness
    rect(map(airlines[i],0,33,0,width),height/2,30,100);
  } 
}

void draw(){
  
}
