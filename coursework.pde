Table table;
int currentPage;
int prevPage;
color bkg;

Airline[] airlineAr = new Airline[33];

//buttons
int noofbuttons = 6;
Boolean [] bHover = new Boolean[noofbuttons];
Boolean [] bClick = new Boolean[noofbuttons];
int [] bCPage = new int[noofbuttons];
int [] bNPage = new int[noofbuttons];
int [] bX = new int[noofbuttons];
int [] bY = new int [noofbuttons];
int [] bW = new int [noofbuttons];
int [] bH = new int [noofbuttons];
color [] bColour = new color [noofbuttons];
color [] bAltColour = new color [noofbuttons];

int graphBase;
int graphTop;
int graphLeft;
int graphRight;
Boolean lineGraph;
Boolean zoom;


void setup() {
  size(1200, 800);
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


  lineGraph = true;
  zoom = false;
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
    bColour[i] = color(190, 100, 45);
    bAltColour[i] = color(181, 93, 59);
  }

  //for (int j=0; j < airline.length; j++) {
  //  hue[j] = map(j, 0, 32, 0, 340);
  //  fill(hue[j], int(random(50, 70)), int(random(90, 100))); // hue, saturation, brightness
  //  //println(j,hue[j]);
  //  rect(map(j, 0, 33, 0, width), height/2, 30, 100);
  //}
}

void draw() {
  mouseCheck();
  buttonCollision();
  //println("TEST - lineGraph",lineGraph);
  if (currentPage == 0) {
    menuPage();
  } else if (currentPage == 1) {
    incidentsPage();
  } else if (currentPage == 2) {
    fatalAccidentsPage();
  } else if (currentPage == 3) {
    fatalitiesPage();
  } 
  //println("TEST - current page",currentPage);
}

void mouseCheck() {
  if (mousePressed) {
    for (int i =0; i<noofbuttons; i++) {
      if (bHover[i] == true) {
        if (bNPage[i] == 6) { //if toggle line/bar
          println("TEST - toggle");
          if (lineGraph == true) {
            lineGraph = false; //bar graph
          } else {
            lineGraph = true;
          }
          //} else if (bNPage[i] == 7) {
          //  println("TEST - zoom");
          //  if (zoom == true) {
          //    zoom = false; //not zoom
          //  } else {
          //    zoom = true;
          //  }
          //}
        } else {
          currentPage = bNPage[i];
        }
      }
    }
  }
}

void drawButtons(int page) {
  noStroke();
  for (int i=0; i<noofbuttons; i++) {
    if (bCPage[i] == page) {
      //println("TEST - draw button");
      if (bHover[i] == true) {
        fill(bAltColour[i]);
      } else {
        fill(bColour[i]);
      }
      rect(bX[i], bY[i], bW[i], bH[i]);
    }
  }
}

void buttonCollision() {
  for (int i = 0; i<noofbuttons; i++) {
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

void drawText(String text, int size, int x, int y) {
  fill(0, 0, 99);
  textSize(size);
  text(text, x, y);
}

void menuPage() {
  background(bkg);
  //make buttons
  bCPage[0] = 0;
  bNPage[0] = 1;
  bY[0] = 300;

  bCPage[1] = 0;
  bNPage[1] = 2;
  bY[1] = 400;
  bColour[1] = color(39, 100, 93);
  bAltColour[1] = color(45, 63, 93);

  bCPage[2] = 0;
  bNPage[2] = 3;
  bY[2] = 500;
  bColour[2] = color(358, 78, 61);
  bAltColour[2] = color(5, 90, 80);

  drawButtons(0);
  drawText("Airline Safety", 80, width/2, 200);
  drawText("Incidents", 40, bX[0], bY[0]+15);
  drawText("Fatal Accidents", 40, bX[1], bY[1]+15);
  drawText("Fatalities", 40, bX[2], bY[2]+15);

  //println("TEST - current page", currentPage);
}

void drawGraph(int topVal) {
  //topVal+=10;
  //println("TEST - draw graph");
  stroke(0, 0, 86);
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
    stroke(0, 0, 50);
    line(graphLeft, graphBase-(interval*i), graphRight, graphBase-(interval*i));
    String temp = str((i*div));
    drawText(temp, 20, graphLeft - 20, int(graphBase-(interval*i)));
  }
}

void incidentsPage() { //page 1
  background(bkg);
  textSize(70);
  drawText("Incidents in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);

  bCPage[3] = currentPage;
  bNPage[3] = 0;
  bX[3] = 120;
  bY[3] = 50;
  bW[3] = 200;

  bCPage[4] = currentPage; //toggle button
  bNPage[4] = 6;
  bX[4] = width - 120;
  bY[4] = 50;
  bW[4] = 200;

  bCPage[5] = currentPage; //zoom button
  bNPage[5] = 7;
  bX[5] = width - 120;
  bY[5] = 130;
  bW[5] = 200;


  int topVal = 80; //30
  drawGraph(topVal);//30
  for (int i=0; i<table.getRowCount(); i++) {
    if (lineGraph == true) {
      airlineAr[i].drawLine(currentPage, topVal); //30
    } else {
      println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage, topVal, i); //30
    }
  }

  drawButtons(currentPage);
  drawText("Main Menu", 30, bX[3], bY[3]+10);
  drawText("line/bar", 30, bX[4], bY[4]+10);
  drawText("toggle zoom", 30, bX[5], bY[5]+10);
}

void fatalAccidentsPage() { //page 2
  background(bkg);
  drawText("Fatal Accidents in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);  

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

  bCPage[5] = currentPage; //zoom button
  bNPage[5] = 7;
  bX[5] = width - 120;
  bY[5] = 130;
  bW[5] = 200;

  drawButtons(currentPage);
  drawText("Main Menu", 30, bX[3], bY[3]+10);
  drawText("line/bar", 30, bX[4], bY[4]+10);

  int topVal = 20; //10
  drawGraph(topVal); //10
  for (int i=0; i<table.getRowCount(); i++) {
    if (lineGraph == true) {
      airlineAr[i].drawLine(currentPage, topVal); //10
    } else {
      println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage, topVal, i); //10
    }
  }

  drawButtons(currentPage);
  drawText("Main Menu", 30, bX[3], bY[3]+10);
  drawText("line/bar", 30, bX[4], bY[4]+10);
  drawText("toggle zoom", 30, bX[5], bY[5]+10);
}

void fatalitiesPage() { //page 3
  background(bkg);
  drawText("Fatalities in 1985 - 1999 vs 2000 - 2014", 30, width/2, 60);
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

  bCPage[5] = currentPage; //zoom button
  bNPage[5] = 7;
  bX[5] = width - 120;
  bY[5] = 130;
  bW[5] = 200;

  int topVal = 540; //300

  drawGraph(topVal); //300
  for (int i=0; i<table.getRowCount(); i++) {
    if (lineGraph == true) {
      println("TEST - line graph");
      airlineAr[i].drawLine(currentPage, topVal); //300
    } else {
      println("TEST - bar chart");
      airlineAr[i].drawBar(currentPage, topVal, i); //300
    }
  }
  drawButtons(currentPage);
  drawText("Main Menu", 30, bX[3], bY[3]+10);
  drawText("line/bar", 30, bX[4], bY[4]+10);
  drawText("toggle zoom", 30, bX[5], bY[5]+10);
}
