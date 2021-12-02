class Button {
  int xPos;
  int yPos;
  color regColour;
  color overColour;
  Boolean mouseOver;
  String text;
  int function;
  int w;
  int h;
  int currentPage;
  int prevPage;


  //constructor
  Button(int x, int y, color rColour, color oColour, String msg, int func, int cPage) {
    xPos = x;
    yPos = y;
    regColour = rColour;
    overColour = oColour;
    mouseOver = false;
    text = msg;
    function = func;
    w = 340;
    h = 60;
    currentPage = cPage;
    prevPage = 0;
  }

  void drawButton() {
    if (mouseOver = false) {
      fill(regColour);
      //println(" ");
      //println(text, "light colour");
    } else if (mouseOver = true) {
      fill(overColour);
      //println(text, "dark colour");
    }
    rect(xPos, yPos, w, h);
    textSize(30);
    fill(0, 0, 99);
    text(text, xPos, yPos+10);
  }

  void checkCollision() {
    if (mouseX < xPos + 170 && mouseX > xPos - 170) {
      if (mouseY < yPos + 30 && mouseY > yPos -30) {
        mouseOver = true;
        println(" ");
        println("TEST - mouse over", text, mouseOver);
      }
    } //else {
    //  mouseOver = false;
    //}
  }

  void click() {
    if (mouseOver = true) {
      //println(" ");
      println("TEST - click", text);
      if (function == 1){
        currentPage = 1;
      } else if (function == 2){
        currentPage = 2;
      } else if (function == 3){
        currentPage = 3;
      }
  }

}
  void keyPress(){
    println("TEST - key pressed");
      if (key == BACKSPACE) {
        println(" ");
        println("TEST - backspace",text);
        currentPage =  prevPage;
      } else if(key == 0) {
        currentPage = 0;
      } else if(key == 1) {
        currentPage = 1;
      } else if(key == 2) {
        currentPage = 2;
      } else if(key == 3) {
        currentPage = 3;
      }
      }




}//end class
