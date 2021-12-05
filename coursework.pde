Table table;
int currentPage;
int prevPage;
color bkg;
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
color bColour;
color bAltColour;

int graphBase;
int graphTop;
int graphLeft;
int graphRight;
Boolean lineGraph;
Boolean zoom;
Boolean widthASK;
Boolean selectionOnly;


void setup() {
  smooth(2);
  myFont = createFont("Trebuchet MS", 15);
  textFont(myFont);
  size(1200, 800);
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

  table.sort(1);
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

void draw() {
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
    if (mouseX < bX[i] + bW[i]/2 && mouseX > bX[i] - bW[i]/2) {
      if (mouseY < bY[i] + bH[i]/2 && mouseY > bY[i] -bH[i]/2) {
        if (bCPage[i] == currentPage) {
          bHover[i] = true;
        }
      }
    } else {
      bHover[i] = false;
    }
  }

  //line collision
  if (currentPage > 0 && currentPage < 4) {
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

void mousePressed() {
  for (int i =0; i<noofbuttons; i++) {
    if (bHover[i] == true) {
      if (bNPage[i] < 4) currentPage = bNPage[i];
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

void drawButtons(int page) {
  //noStroke();
  strokeWeight(4);
  colorMode(HSB, 360, 100, 100);
  for (int i=0; i<noofbuttons; i++) {
    if (bCPage[i] == page) {
      //println("TEST - draw button");
      if (bHover[i] == true) {
        fill(bAltColour);
        stroke(bColour);
      } else {
        fill(bColour);
        stroke(bAltColour);
      }
      rect(bX[i], bY[i], bW[i], bH[i]);
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
      println("TEST - draw text",bText[i]);
      //drawText(bText[i],40,bX[i],bY[i]+10);
    }
  }
}

void drawText(String text, int size, int x, int y) {
  textAlign(CENTER);
  fill(bColour);
  textSize(size);
  text(text, x, y);
}

void menuPage() {
  background(bkg);
  //make buttons
  bCPage[0] = 0;
  bNPage[0] = 1;
  bY[0] = 300;
  bText[0] = "Incidents";
  bSize[0] = 40;

  bCPage[1] = 0;
  bNPage[1] = 2;
  bY[1] = 400;
  bText[1] = "Fatal Accidents";
  bSize[1] = 40;

  bCPage[2] = 0;
  bNPage[2] = 3;
  bY[2] = 500;
  bText[2] = "Fatalities";
  bSize[2] = 40;
  
  bCPage[9] = 0;
  bNPage[9] = 4;
  bY[9] = 600;
  bText[9] = "How to use";
  bSize[9] = 40;

  drawButtons(0);
  drawText("Airline Safety", 80, width/2, 200);
  if (bHover[0] == true) fill(0,0,0);
  else fill(0,0,99);
  //drawText("Incidents", 40, bX[0], bY[0]+15);
  //drawText("Fatal Accidents", 40, bX[1], bY[1]+15);
  //drawText("Fatalities", 40, bX[2], bY[2]+15);
}

void drawGraph(int topVal) {
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
    drawText(temp, 20, graphLeft - 20, int(graphBase-(interval*i)));
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

void drawData(int currentPage, int regTopVal, int altTopVal) {
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

void incidentsPage() { //page 1
  background(bkg);
  textSize(70);
  drawData(currentPage, 80, 30);
  drawText("Incidents in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);
  drawButtons(currentPage);
  //drawText("Main Menu", 30, bX[3], bY[3]+10);
  //drawText("Line/Bar\ngraph", 15, bX[4], bY[4]-5);
  //drawText("Zoom\nin/out", 15, bX[5], bY[5]-5);
  //drawText("Line \nwidth", 15, bX[6], bY[6]-5);
  //drawText("Selected\nonly", 15, bX[7], bY[7]-5);
  //drawText("Clear", 20, bX[8], bY[8]+10);
}

void fatalAccidentsPage() { //page 2
  background(bkg);
  drawData(currentPage, 20, 10);
  drawText("Fatal Accidents in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);  
  drawButtons(currentPage);
  //drawText("Main Menu", 30, bX[3], bY[3]+10);
  //drawText("Line/Bar\ngraph", 15, bX[4], bY[4]-5);
  //drawText("Zoom\nin/out", 15, bX[5], bY[5]-5);
  //drawText("Line \nwidth", 15, bX[6], bY[6]-5);
  //drawText("Selected\nonly", 15, bX[7], bY[7]-5);
  //drawText("Clear", 20, bX[8], bY[8]+10);
}

void fatalitiesPage() { //page 3
  background(bkg);
  drawData(currentPage, 600, 300);
  drawText("Fatalities in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);
  drawButtons(currentPage);
  //drawText("Main Menu", 30, bX[3], bY[3]+10);
  //drawText("Line/Bar\ngraph", 15, bX[4], bY[4]-5);
  //drawText("Zoom\nin/out", 15, bX[5], bY[5]-5);
  //drawText("Line \nwidth", 15, bX[6], bY[6]-5);
  //drawText("Selected\nonly", 15, bX[7], bY[7]-5);
  //drawText("Clear", 20, bX[8], bY[8]+10);
}

void infoPage(){ //page 4
  background(bkg);
  drawText("How to use", 30, width/2, 60);
  drawText("This is a data visualisation of 33 different airlines showing how they compared between two\n time frames (1959 to 1999 and 2000 to 2014). There are three different pages which can be navigated to through the main menu. \nThe line graphs show the different in values the slope of the line. The width of the line \nrepresents the (ASK) available seats per kilometre per week (the popularity of the airline) this\n can be toggled on/off using the ‘line width’ button to more clearly see some of the lines. \nTo more easily see some of the lower values, you can click the ‘Zoom in/out’ button which \nwill decrease the range of the y axis, more clearly showing the lower values. \nBy hovering over lines, you can see more information  about the respective airline. By clicking\n a line, this box will stay and then you can click the ‘selected only’ button to show only those\n lines. Press ‘clear’ to clear your selection. You can also select lines by clicking on\n the name in the legend.\nYou can also view the data in bar chart form by clicking the ‘Line/bar graph’ button. ",20,width/2,100);
}
