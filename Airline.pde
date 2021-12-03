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
  
  //line collision
  float startX;
  float startY;
  float endX;
  float endY;
  boolean lineHit;
  boolean selected;
  int selectedX;
  int selectedY;
  
  //legend collision
  int legendX;
  int legendY;
  
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
    startX = graphLeft;
    endX = graphRight;

  }
  
  void drawLine(int page, int topVal){
    //table.sort(1);
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
    startY = map(startY, 0, topVal, graphBase, graphTop);
    endY = map(endY, 0, topVal, graphBase, graphTop);
    if (lineHit) stroke(hue,50,70);
    else stroke(hue,60,90);
    float weight;
    if (widthASK){
      if ((ASK / 100000000)*2<1.5){
        weight = 1.5;
      } else{
        weight = (ASK / 100000000)*2;
      }
    } else weight = 1.5;
    strokeWeight(weight);
    if (selected && selectionOnly){
      line(graphLeft,startY,graphRight,endY);
    } else if (selectionOnly == false){
      line(graphLeft,startY,graphRight,endY);
    }
  }
  
  boolean linePoint(){ //line collision
    //distance between mouse and ends of line
    float d1 = dist(mouseX,mouseY, startX, startY);
    float d2 = dist(mouseX,mouseY, endX, endY);
    
    float lineLen = dist(startX, startY, endX, endY); //finds lenght of line
    
    float buffer = 0.5; //higher buffer,less accuracy
    
    if(d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer){
      //println("TEST - line collision!");
      if (mousePressed){
        if ((selectionOnly && selected) || !selectionOnly){
        selected = true; 
        selectedX = mouseX;
        selectedY = mouseY;
        }
      }
      return true;  
      
    }
    //if (mousePressed) selected = false;
    return false;
  }
  
  void drawBar (int page, int topVal,int i){
    rotate(0);
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
    
  }
  
  //void drawBarText(int i){
  //  //println("TEST - draw bar text");
  //  fill(0,0,99);
  //  rotate(radians(270));
  //  textAlign(CENTER,CENTER);
  //  //translate(graphLeft+100,graphBase +200);
  //  //rotate(HALF_PI);
  //  text(n,20 + graphLeft+(i*100)-200,graphBase + 20*i);
  //  //text(n,0,0);

  //  rotate(radians(-270));
  //}
  
  
  void drawLegend(int i, int j){
    fill(0,0,99);
    
    //rect(graphLeft+100*j,(graphBase+30*i)+20,90.0,20);
    if (selected){
      fill(0,0,99);
    } else fill(hue,60,90);
    textSize(13);
    textAlign(LEFT);
    if (n.length() > 9){
      textSize(9);
    }
    legendX = (graphLeft+100*j)-50;
    legendY = (graphBase+30*i)+20;
    text(n,legendX,legendY);
    textAlign(CENTER); 
  }
  
  void legendCollision(){
    if (mouseX < legendX + 45 && mouseX > legendX - 45){
      if (mouseY < legendY + 10 && mouseY > legendY - 10){
        //println("TEST - legend collision");
        if (mousePressed){
          selected = true;
        }
      }
    }
  }
  
  void drawInfoBox(){
    noStroke();
    int xPos = mouseX-100;
    if (mouseX <width/2) xPos = mouseX+100;
    int yPos = mouseY-50;
    if (selected){
      xPos = selectedX;
      yPos = selectedY;
      fill(hue,60,100,150);
    }  
    if ((selectionOnly && selected) || !selectionOnly){
      fill(hue,60,100,100);
      rect(xPos, yPos,200,120,10);
      fill(0,0,99);
      if (n.length() > 15){
        textSize(16);
      }else{
        textSize(20);
      }
      text(n,xPos,yPos-35);
      textSize(15);
      text("ASK: "+nfc(ASK), xPos, yPos -15); //add commas later
      text("Incidents: "+ inc85 + " -> " + inc00, xPos, yPos+5);
      text("Fatal Accidents: "+ fatal85 + " -> " + fatal00, xPos, yPos+25);
      text("Fatalities: "+ fatalities85 + " -> " + fatalities00, xPos, yPos+45);
    }
  }
  
  void deselect(){
    if (selected){
      println("TEST - deselect "+n);
      selected = false; 
    }
  }
  
  
}//end class
