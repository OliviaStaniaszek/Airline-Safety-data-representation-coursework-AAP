import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class coursework extends PApplet {

Table table;
int currentPage;
int prevPage;
int bkg;
PFont myFont;

Airline[] airlineAr = new Airline[33];

//buttons
int noofbuttons = 10;
Boolean [] bHover = new Boolean[noofbuttons];
Boolean [] bClick = new Boolean[noofbuttons];
int [] bCPage = new int[noofbuttons];
int [] bNPage = new int[noofbuttons];
int [] bX = new int[noofbuttons];
int [] bY = new int [noofbuttons];
int [] bW = new int [noofbuttons];
int [] bH = new int [noofbuttons];
String [] bText = new String [noofbuttons];
int [] bSize = new int [noofbuttons];
int bColour;
int bAltColour;

int graphBase;
int graphTop;
int graphLeft;
int graphRight;
Boolean lineGraph;
Boolean zoom;
Boolean widthASK;
Boolean selectionOnly;


public void setup() {
  
  myFont = createFont("Trebuchet MS", 15);
  textFont(myFont);
  
  currentPage = 0;
  prevPage = 0;
  colorMode(HSB, 360, 100, 100);
  noStroke();
  textAlign(CENTER);
  rectMode(CENTER);
  bkg = color(230, 40, 12);
  graphBase = height - 100;
  graphTop = 100;
  graphLeft = 100;
  graphRight = width - 100;
  bColour = color(45, 79, 88);
  bAltColour = color(240, 50, 10);


  lineGraph = true;
  zoom = false;
  widthASK = true;
  selectionOnly = false;
  table=loadTable("airlineSafety.csv", "header");// if the data has a header row, use "header"
  int rows = table.getRowCount();
  println(rows + " total rows in table");

  String [] airline = new String[rows];
  int [] ASK = new int[rows];
  int [] inc8599 = new int[rows];
  int [] fatal8599 = new int[rows];
  int [] fatalities8599 = new int[rows];
  int [] inc0014 = new int[rows];
  int [] fatal0014 = new int[rows];
  int [] fatalities0014 = new int[rows];
  float [] hue = new float[rows];

  table.sort(1);// sort table by ask

  for (int i=0; i<table.getRowCount(); i++) {
    TableRow row = table.getRow(i);
    airline[i] = row.getString("airline");
    ASK[i] = row.getInt("avail_seat_km_per_week");
    inc8599[i] = row.getInt("incidents_85_99");
    fatal8599[i] = row.getInt("fatal_accidents_85_99");
    fatalities8599[i] = row.getInt("fatalities_85_99");
    inc0014[i] = row.getInt("incidents_00_14");
    fatal0014[i] = row.getInt("fatal_accidents_00_14");
    fatalities0014[i] = row.getInt("fatalities_00_14");
    hue[i] = map(i, 0, 32, 0, 340);
    airlineAr[i] = new Airline(airline[i], ASK[i], inc8599[i], fatal8599[i], fatalities8599[i], inc0014[i], fatal0014[i], fatalities0014[i], hue[i], graphBase, graphTop, graphLeft, graphRight);
    //println(airline[i], ASK[i], inc8599[i], fatal8599[i], fatalities8599[i]);
  }

  for (int i = 0; i<noofbuttons; i++) {//loop though number of buttons
    bHover[i] = false;
    bClick[i] = false;
    bCPage[i] = currentPage;
    bNPage[i] = 0;
    bX[i] = width/2;
    bY[i] = height/2;
    bW[i] = 340;
    bH[i] = 60;
    bText[i] = "";
    bSize[i] = 15;
  }
}

public void draw() {
  if (currentPage == 0) {
    menuPage();
  } else if (currentPage == 1) {
    incidentsPage();
  } else if (currentPage == 2) {
    fatalAccidentsPage();
  } else if (currentPage == 3) {
    fatalitiesPage();
  } else if (currentPage == 4) {
    infoPage();
  }
  
  for (int i = 0; i<noofbuttons; i++) { //button collisions
    if (mouseY < bY[i] + bH[i]/2 && mouseY > bY[i] -bH[i]/2 && mouseX < bX[i] + bW[i]/2 && mouseX > bX[i] - bW[i]/2) {
      if (bCPage[i] == currentPage) {
        bHover[i] = true;
      }
    } else {
      bHover[i] = false;
    }
  }

  //line collision
  if (currentPage > 0 && currentPage < 4){
      for (int i=0; i<table.getRowCount(); i++) {
        boolean hit = airlineAr[i].linePoint();
        boolean selected = airlineAr[i].selected;
        airlineAr[i].legendCollision();
        if ((hit || selected) && lineGraph) airlineAr[i].drawInfoBox(lineGraph);
    }
  }
  
  ////bar collision
  //if (currentPage > 0 && currentPage < 4) {
  //  for (int i=0; i<table.getRowCount(); i++) {
  //    Boolean hit = airlineAr[i].barCollision(i);
  //  }
  //}
}

//boolean freezeLineCollision(){
//  int count = 0;
//  for (int i=0; i<table.getRowCount(); i++) {
//    boolean hit = airlineAr[i].linePoint();
//    if (hit) count ++;
//  }
//  if (count > 1) return true;
//  else return false;
//}

public void mousePressed() {
  for (int i =0; i<noofbuttons; i++) {
    if (bHover[i] == true) {
      if (bNPage[i] < 5) currentPage = bNPage[i];
      else {
        switch(bNPage[i]) {
        case 6:
          if (lineGraph == true) {
            lineGraph = false; //bar graph
          } else {
            lineGraph = true;
          }
          break;
          
        case 7:
          if (zoom == true) {
            zoom = false; //not zoom
          } else {
            zoom = true;
          }
          break;
          
        case 8:
          //println("TEST - widthASK");
          if (widthASK == true) {
            widthASK = false;
          } else {
            widthASK = true;
          }
          break;
        case 9:
         if (selectionOnly == true) {
            selectionOnly = false;
          } else {
            selectionOnly = true;
          }
          break;
        case 10:
          //println("TEST - clear button pressed");
          for(int j =0; j< table.getRowCount();j++){
            airlineAr[j].deselect();
          }
          break;
        }
      }
    }
  }
}

public void drawButtons(int page) {
  strokeWeight(4);
  colorMode(HSB, 360, 100, 100);
  for (int i=0; i<noofbuttons; i++) {
    if (bCPage[i] == page) {
      //println("TEST - draw button");
      if (bHover[i] == true) {//changes colour when hovering
        fill(bAltColour);
        stroke(bColour);
      } else {
        fill(bColour);
        stroke(bAltColour);
      }
      //println("TEST - draw rectangle",i);
      rect(bX[i], bY[i], bW[i], bH[i],10);
    }
    int offset = -5;
    if (page >0){
      offset = -2;
    } 
    
    textAlign(CENTER, CENTER);
    if (bCPage[i] == page){
      if(bHover[i]) fill(bColour);
      else fill(bAltColour);
      
      textSize(bSize[i]);
      text(bText[i],bX[i],bY[i]+offset);
      println("TEST - draw text",bText[i],i);
      //drawText(bText[i],40,bX[i],bY[i]+10);
    }
  }
}

public void drawText(String text, int size, int x, int y) {
  textAlign(CENTER);
  fill(bColour);
  textSize(size);
  text(text, x, y);
}

public void menuPage() {
  background(bkg);
  //make buttons
  bCPage[0] = currentPage;
  bNPage[0] = 1;
  bY[0] = 300;
  bText[0] = "Incidents";
  bSize[0] = 40;

  bCPage[1] = currentPage;
  bNPage[1] = 2;
  bY[1] = 400;
  bText[1] = "Fatal Accidents";
  bSize[1] = 40;

  bCPage[2] = currentPage;
  bNPage[2] = 3;
  bY[2] = 500;
  bText[2] = "Fatalities";
  bSize[2] = 40;
  
  bCPage[9] = currentPage;
  bNPage[9] = 4;
  bY[9] = 600;
  bText[9] = "How to use";
  bSize[9] = 40;

  drawButtons(currentPage);
  drawText("Airline Safety", 80, width/2, 200);
  
  //drawText("Incidents", 40, bX[0], bY[0]+15);
  //drawText("Fatal Accidents", 40, bX[1], bY[1]+15);
  //drawText("Fatalities", 40, bX[2], bY[2]+15);
}

public void drawGraph(int topVal) {
  //topVal+=10;
  //println("TEST - draw graph");
  stroke(0, 0, 86);
  strokeWeight(1);
  line(graphLeft, graphTop, graphLeft, graphBase);
  line(graphRight, graphTop, graphRight, graphBase);
  line(graphLeft, graphBase, graphRight, graphBase);
  int div = 10;
  if (topVal > 200) {
    div = 100;
  } else if (topVal < 50) {
    div = 5;
  }

  int noofgridlines = topVal / div;
  float interval = (graphBase - graphTop)/noofgridlines-1;
  //println("TEST - interval",interval);
  //println("TEST - no of grid lines",noofgridlines);
  for (int i = 0; i < noofgridlines; i++) {
    //float g = map(noofgridlines, 0, topVal, graphTop, graphBase);
    stroke(0, 0, 25);
    line(graphLeft, graphBase-(interval*i), graphRight, graphBase-(interval*i));
    String temp = str((i*div));
    drawText(temp, 20, graphLeft - 20, PApplet.parseInt(graphBase-(interval*i)));
  }
  fill(bColour);
  float x = graphLeft-40;
  float y = height/2;
  textAlign(CENTER,BOTTOM);

  pushMatrix();
  translate(x,y);
  rotate(-HALF_PI);
  text("1985-1999", 0,0);
  popMatrix();
  
  pushMatrix(); 
  x = graphRight+30;
  translate(x,y);
  rotate(-HALF_PI);
  text("2000-2014", 0,0);
  popMatrix();
  textAlign(CENTER);
}

public void drawData(int currentPage, int regTopVal, int altTopVal) {
  bCPage[3] = currentPage; //menu button
  bNPage[3] = 0;
  bX[3] = 120;
  bY[3] = 50;
  bW[3] = 200;
  bH[3] = 50;
  bText[3] = "Main Menu";
  bSize[3] = 25;

  bCPage[4] = currentPage; //toggle line bar chart button
  bNPage[4] = 6;
  bX[4] = width - 200;
  bY[4] = 50;
  bW[4] = 100; //200;
  bH[4] = 50;
  bText[4] = "Line/bar\ngraph";

  bCPage[5] = currentPage; //zoom button
  bNPage[5] = 7;
  bX[5] = width - 80;
  bY[5] = 50; //105;
  bW[5] = 100; //200;
  bH[5] = 50;
  bText[5] = "Zoom\nin/out";

  bCPage[6] = currentPage; //line width toggle button
  bNPage[6] = 8;
  bX[6] = width-200; //width - 120;
  bY[6] = 120; //160;
  bW[6] = 100; ///200;
  bH[6] = 50;
  bText[6] = "Line\nwidth";
  
  bCPage[7] = currentPage; //selected only
  bNPage[7] = 9;
  bX[7] = width - 80;
  bY[7] = 120; //105;
  bW[7] = 100; //200;
  bH[7] = 50;
  bText[7] = "Selected\nonly";
  
  bCPage[8] = currentPage; //clear selection
  bNPage[8] = 10;
  bX[8] = width-80;
  bY[8] = 190;
  bW[8] = 100;
  bH[8] = 50;
  bText[8] = "Clear";
  bSize[8] = 20;

  int topVal;
  for (int i=0; i<table.getRowCount(); i++) {
    if (zoom == false) {
      topVal = regTopVal;
    } else {
      topVal = altTopVal;
    }
    drawGraph(topVal);//30
    if (lineGraph == true) {
      airlineAr[i].drawLine(currentPage, topVal);
    } else {
      //println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage, topVal, i);
      airlineAr[i].drawBarLabel(i);
    }
  }
  int count = 0;
  if (lineGraph){
    for (int i=0; i<3; i++) { //cols
      for (int j=0; j<11; j++) { //rowz
        airlineAr[count].drawLegend(i, j);
        count ++;
      }
    }
  }
  fill(bkg);
  noStroke();
  rect(width/2, 50, width, 140);
}

public void incidentsPage() { //page 1
  background(bkg);
  drawData(currentPage, 80, 30);
  drawText("Incidents in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);
  drawButtons(currentPage);

}

public void fatalAccidentsPage() { //page 2
  background(bkg);
  drawData(currentPage, 20, 10);
  drawText("Fatal Accidents in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);  
  drawButtons(currentPage);

}

public void fatalitiesPage() { //page 3
  background(bkg);
  drawData(currentPage, 600, 300);
  drawText("Fatalities in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);
  drawButtons(currentPage);

}

public void infoPage(){ //page 4
  background(bkg);
  drawText("How to use", 50, width/2, 90);
  bCPage[3] = currentPage; //menu button
  bNPage[3] = 0;
  bX[3] = 120;
  bY[3] = 50;
  bW[3] = 200;
  bH[3] = 50;
  bText[3] = "Main Menu";
  bSize[3] = 25;
  drawButtons(currentPage);
  drawText("This is a data visualisation of 33 different airlines showing how they compared between two\n time frames (1985 to 1999 and 2000 to 2014). There are three different pages which can be navigated\nto through the main menu.",20,width/2,140);
  drawText("The line graphs show the difference in values by the slope of the line. The width of the line \nrepresents the (ASK) available seats per kilometre per week (the popularity of the airline)* this\n can be toggled on/off using the ‘line width’ button to more clearly see some of the lines. ",20,width/2,250);
  drawText("To more easily see some of the lower values, you can click the ‘Zoom in/out’ button which \nwill decrease the range of the y axis, more clearly showing the lower values. \nBy hovering over lines, you can see more information  about the respective airline. By clicking\n a line, this box will stay and then you can click the ‘selected only’ button to show only those\n lines. Press ‘clear’ to clear your selection.",20,width/2,360); 
  drawText("You can also select lines by clicking on the name in the legend.\nYou can view the data in bar chart form by clicking the ‘Line/bar graph’ button. ",20,width/2,530);
  drawText("*Line width values are calculated through an equation (ASK / 100000000)*2)\n however lines with a width under 1.5 pixels were given a width of 1.5 as smaller values were too faint.",20,width/2,600);

}
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
  
  int topVal;
  
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
  
  public void drawLine(int page, int topVal){
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
      if ((ASK / 100000000)*2<1.5f){
        weight = 1.5f;
      } else{
        weight = (ASK / 100000000)*2;
      }
    } else weight = 1.5f;
    strokeWeight(weight);
    if (selected && selectionOnly){
      line(graphLeft,startY,graphRight,endY);
    } else if (selectionOnly == false){
      line(graphLeft,startY,graphRight,endY);
    }
  }
  
  public boolean linePoint(){ //line collision
    //distance between mouse and ends of line
    float d1 = dist(mouseX,mouseY, startX, startY);
    float d2 = dist(mouseX,mouseY, endX, endY);
    
    float lineLen = dist(startX, startY, endX, endY); //finds lenght of line
    
    float buffer = 0.5f; //higher buffer,less accuracy
    if (widthASK == false) buffer = 0.1f;//more accuracy when showing thin lines
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
  
  public float[] mapBar (int page, int topVal){
    int bar85 = 0;
    int bar00 = 0;
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
    float [] bars = new float[2];
    bars[0] = bar1;
    bars[1] = bar2;
    return bars;
  }
  public void drawBar (int page, int topVal,int i){
    float[] bars = mapBar(page,topVal);
    float bar1 = bars[0];
    float bar2 = bars[1];
    int w = 10; //width of bar
    noStroke();
    fill(hue,60,90);
    rect(15 + graphLeft+(i*30),graphBase-bar1/2,w,bar1);
    fill(hue,40,90);
    rect(26 + graphLeft+(i*30),graphBase-bar2/2,w,bar2);
    
  }
  
  //Boolean barCollision(int page, int i){
  //  float[] bars = mapBar(page,topVal);
  //  float bar1 = bars[0];
  //  float bar2 = bars[1];
  //  //int w = 10//width of bar
  //  Boolean hit = false;
  //  if (mouseX > (15 + graphLeft+(i*30))-5 && mouseX < (15 + graphLeft+(i*30))+ 5){
  //    if(mouseY < (graphBase-bar1/2) && (mouseY > bar1 || mouseY  > bar2)){
  //      println("TEST - bar collision "+n);
  //    }
  //  }
  // return hit;
  //}
  
  
  
  public void drawLegend(int i, int j){
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
  
  public void legendCollision(){
    if (mouseX < legendX + 45 && mouseX > legendX - 45){
      if (mouseY < legendY + 10 && mouseY > legendY - 10){
        //println("TEST - legend collision");
        if (mousePressed){
          selected = true;
        }
      }
    }
  }
  
  public void drawBarLabel(int i){
    fill(bColour);
    textSize(15);
    if (n.length() > 19){
      textSize(10);
    } else if(n.length() > 15){
      textSize(13);
    } else if(n.length() > 10){
      textSize(14);
    }
    float x = 25 + graphLeft+(i*30);
    float y = graphBase+15;
    textAlign(RIGHT);
    pushMatrix();
    translate(x,y);
    rotate(-QUARTER_PI);
    text(n,0,0);
    popMatrix();
  }
  
  public void drawInfoBox(Boolean lineGraph){
    textAlign(CENTER);
    noStroke();
    int xPos = width/2;
    int yPos = height/2;
    if (lineGraph){
      xPos = mouseX-100;
      if (mouseX <width/2) xPos = mouseX+100;
      yPos = mouseY-50;
    }
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
  
  public void deselect(){
    if (selected){
      //println("TEST - deselect "+n);
      selected = false; 
    }
  }
  
  
}//end class
  public void settings() {  size(1200, 800);  smooth(2); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "coursework" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
