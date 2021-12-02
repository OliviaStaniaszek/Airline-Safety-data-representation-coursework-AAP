class Airline {
  String n;
  int ASK;
  int inc85;
  int fatal85;
  int fatalities85;
  int inc00;
  int fatal00;
  int fatalities00;
  float hue;
  int graphBase;
  int graphTop;
  int graphLeft;
  int graphRight;
  
  Airline(String name, int ASK, int inc8599, int fatal8599, int fatalities8599, int inc0014, int fatal0014, int fatalities0014, float hue, int gBase, int gTop, int gLeft, int gRight){
    n = name;
    this.ASK = ASK;
    inc85 = inc8599;
    fatal85 = fatal8599;
    fatalities85 = fatalities8599;
    inc00 = inc0014;
    fatal00 = fatal0014;
    fatalities00 = fatalities0014;
    this.hue = hue;
    graphBase = gBase;
    graphTop = gTop;
    graphLeft = gLeft;
    graphRight = gRight;
  }
  
  void drawLine(int page, int topVal){
    int startY = 0;
    int endY = 0;
    if (page == 1){
      startY = inc85;
      endY = inc00;
    } else if(page == 2){
      startY = fatal85;
      endY = fatal00;
    } else if(page == 3) {
      startY = fatalities85;
      endY = fatalities00;
    }
    float start = map(startY, 0, topVal, graphBase, graphTop);
    float end = map(endY, 0, topVal, graphBase, graphTop);
    stroke(hue,60,90);
    strokeWeight((ASK / 100000000)*2);
    line(graphLeft,start,graphRight,end);
  }
  
  void drawBar (int page, int topVal,int i){
    int bar85 = 0;
    int bar00 = 0;
    int w = 10; //width of bar
    if (page == 1){
      bar85 = inc85;
      bar00 = inc00;
    } else if(page == 2){
      bar85 = fatal85;
      bar00 = fatal00;
    } else if(page == 3) {
      bar85 = fatalities85;
      bar00 = fatalities00;
    }
    float bar1 = map(bar85, 0, topVal, 0, graphBase-graphTop);
    float bar2 = map(bar00, 0, topVal, 0, graphBase-graphTop);
    noStroke();
    fill(hue,60,90);
    rect(15 + graphLeft+(i*30),graphBase-bar1/2,w,bar1);
    fill(hue,40,90);
    rect(26 + graphLeft+(i*30),graphBase-bar2/2,w,bar2);
    fill(0,0,99);
    //rotate(HALF_PI);
    text(n,20 + graphLeft+(i*30),graphBase + 20);

    
  }
  
}//end class
