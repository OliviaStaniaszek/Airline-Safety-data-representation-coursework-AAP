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

Airline[] airlineAr = new Airline[33];

//buttons
int noofbuttons = 5;
Boolean [] bHover = new Boolean[noofbuttons];
Boolean [] bClick = new Boolean[noofbuttons];
int [] bCPage = new int[noofbuttons];
int [] bNPage = new int[noofbuttons];
int [] bX = new int[noofbuttons];
int [] bY = new int [noofbuttons];
int [] bW = new int [noofbuttons];
int [] bH = new int [noofbuttons];
int [] bColour = new int [noofbuttons];
int [] bAltColour = new int [noofbuttons];

int graphBase;
int graphTop;
int graphLeft;
int graphRight;
Boolean lineGraph;



public void setup() {
  
  currentPage = 0;
  prevPage = 0;
  colorMode(HSB, 360, 100, 100);
  noStroke();
  textAlign(CENTER);
  rectMode(CENTER);
  bkg = color(197, 100, 10);
  graphBase = height - 100;
  graphTop = 100;
  graphLeft = 100;
  graphRight = width - 100;
  
  
  lineGraph = false;
  table=loadTable("airlineSafety.csv", "header");// if the data has a header row, use "header"
  //table.setColumnType(1, Table.INT);
  //table.sort(1);
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
  
  // sort table by ask
  
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
    airlineAr[i] = new Airline(airline[i], ASK[i], inc8599[i], fatal8599[i], fatalities8599[i], inc0014[i], fatal0014[i], fatalities0014[i], hue[i],graphBase, graphTop, graphLeft, graphRight);
    //println(airline[i], ASK[i], inc8599[i], fatal8599[i], fatalities8599[i]);
  }
  
  for (int i = 0; i<noofbuttons; i++){//loop though number of buttons
    bHover[i] = false;
    bClick[i] = false;
    bCPage[i] = currentPage;
    bNPage[i] = 0;
    bX[i] = width/2;
    bY[i] = height/2;
    bW[i] = 340;
    bH[i] = 60;
    bColour[i] = color(190,100,45);
    bAltColour[i] = color(181,93,59);
  }

  //for (int j=0; j < airline.length; j++) {
  //  hue[j] = map(j, 0, 32, 0, 340);
  //  fill(hue[j], int(random(50, 70)), int(random(90, 100))); // hue, saturation, brightness
  //  //println(j,hue[j]);
  //  rect(map(j, 0, 33, 0, width), height/2, 30, 100);
  //}
}

public void draw() {
  mouseCheck();
  buttonCollision();
  println("TEST - lineGraph",lineGraph);
  if (currentPage == 0) {
    menuPage();
  }else if (currentPage == 1) {
    incidentsPage();
  }else if (currentPage == 2) {
    fatalAccidentsPage();
  }else if (currentPage == 3) {
    fatalitiesPage();
  } 
  //println("TEST - current page",currentPage);
}

public void mouseCheck(){
  if (mousePressed){
    for (int i =0; i<noofbuttons;i++){
      if(bHover[i] == true){
        if(bNPage[i] == 6){ //if toggle line/bar
          println("TEST - toggle");
          if (lineGraph == true){
            lineGraph = false; //bar graph
          } else {
            lineGraph = true;
          }
        } else{
        currentPage = bNPage[i];
        }
      }
    }
  }
}

public void drawButtons(int page){
  noStroke();
  for (int i=0; i<noofbuttons;i++){
    if(bCPage[i] == page){
      //println("TEST - draw button");
      if (bHover[i] == true){
        fill(bAltColour[i]);
      } else {
        fill(bColour[i]);
      }
      rect(bX[i],bY[i],bW[i],bH[i]);
    }
  }
}

public void buttonCollision(){
  for (int i = 0; i<noofbuttons; i++){
    if (mouseX < bX[i] + 170 && mouseX > bX[i] - 170) {
      if (mouseY < bY[i] + 30 && mouseY > bY[i] -30) {
        bHover[i] = true;
      }
    } else {
      bHover[i] = false;
    }
    //println(" ");
    //println("TEST - mouse over", i, bHover[i]);
  }
}

public void drawText(String text,int size,int x,int y){
  fill(0,0,99);
  textSize(size);
  text(text,x,y);
}

public void menuPage() {
  background(bkg);
  //make buttons
  bCPage[0] = 0;
  bNPage[0] = 1;
  bY[0] = 300;
  
  bCPage[1] = 0;
  bNPage[1] = 2;
  bY[1] = 400;
  bColour[1] = color(39,100,93);
  bAltColour[1] = color(45,63,93);
  
  bCPage[2] = 0;
  bNPage[2] = 3;
  bY[2] = 500;
  bColour[2] = color(358,78,61);
  bAltColour[2] = color(5,90,80);
  
  drawButtons(0);
  drawText("Airline Safety",80,width/2,200);
  drawText("Incidents",40,bX[0],bY[0]+15);
  drawText("Fatal Accidents",40,bX[1],bY[1]+15);
  drawText("Fatalities",40,bX[2],bY[2]+15);
  
  //println("TEST - current page", currentPage);
}

public void drawGraph(int topVal){
  //topVal+=10;
  //println("TEST - draw graph");
  stroke(0,0,86);
  line(graphLeft, graphTop, graphLeft, graphBase);
  line(graphRight, graphTop, graphRight, graphBase);
  line(graphLeft,graphBase,graphRight,graphBase);
  int div = 10;
  if (topVal > 200){
    div = 100;
  }else if (topVal < 50){
    div = 5;
  }
  
  int noofgridlines = topVal / div;
  float interval = (graphBase - graphTop)/noofgridlines-1;
  //println("TEST - interval",interval);
  //println("TEST - no of grid lines",noofgridlines);
  for (int i = 0; i < noofgridlines; i++){
    //float g = map(noofgridlines, 0, topVal, graphTop, graphBase);
    stroke(0,0,50);
    line(graphLeft,graphBase-(interval*i), graphRight,graphBase-(interval*i));
    String temp = str((i*div));
    drawText(temp,20,graphLeft - 20, PApplet.parseInt(graphBase-(interval*i)));
  }
}

public void incidentsPage() { //page 1
  background(bkg);
  textSize(70);
  drawText("Incidents in 1985 - 1999 vs 2000 - 2014",30,width/2, 60);
  
  bCPage[3] = currentPage;
  bNPage[3] = 0;
  bX[3] = 120;
  bY[3] = 50;
  bW[3] = 200;
  
  bCPage[4] = currentPage;
  bNPage[4] = 6;
  bX[4] = width - 120;
  bY[4] = 50;
  bW[4] = 200;
  drawButtons(currentPage);
  drawText("Main Menu",30,bX[3],bY[3]+10);
  drawText("line/bar",30,bX[4],bY[4]+10);
  
  drawGraph(30);//30
  for (int i=0; i<table.getRowCount(); i++) {
    if (lineGraph == true){
      airlineAr[i].drawLine(currentPage,30); //30
    } else {
      println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage,30,i); //30
    }
  }
}

public void fatalAccidentsPage() { //page 2
  background(bkg);
  drawText("Fatal Accidents in 1985 - 1999 vs 2000 - 2014",30,width/2, 60);  
  
  bCPage[3] = currentPage;
  bNPage[3] = 0;
  bX[3] = 120;
  bY[3] = 50;
  bW[3] = 200;
  
  bCPage[4] = currentPage;
  bNPage[4] = 6;
  bX[4] = width - 120;
  bY[4] = 50;
  bW[4] = 200;
  drawButtons(currentPage);
  drawText("Main Menu",30,bX[3],bY[3]+10);
  drawText("line/bar",30,bX[4],bY[4]+10);
  drawGraph(20); //10
  for (int i=0; i<table.getRowCount(); i++) {
    if (lineGraph == true){
      airlineAr[i].drawLine(currentPage,20); //10
    } else {
      println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage,20,i); //10
    }
  }

}

public void fatalitiesPage() { //page 3
  background(bkg);
  drawText("Fatalities in 1985 - 1999 vs 2000 - 2014",30,width/2, 60);
  bCPage[3] = currentPage;
  bNPage[3] = 0;
  bX[3] = 120;
  bY[3] = 50;
  bW[3] = 200;
  
  bCPage[4] = currentPage;
  bNPage[4] = 6;
  bX[4] = width - 120;
  bY[4] = 50;
  bW[4] = 200;
  drawButtons(currentPage);
  drawText("Main Menu",30,bX[3],bY[3]+10);
  drawText("line/bar",30,bX[4],bY[4]+10);

  drawGraph(540); //300
  for (int i=0; i<table.getRowCount(); i++) {
    if (lineGraph == true){
      airlineAr[i].drawLine(currentPage,540); //300
    } else {
      println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage,540,i); //300
    }
  }

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
  
  public void drawLine(int page, int topVal){
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
  
  public void drawBar (int page, int topVal,int i){
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
  public void settings() {  size(1200, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "coursework" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
