float depth = 2000;
float rX = PI/2;
float rZ = 0;
float rapidity = 0.1;

void settings() {
      size(500, 500, P3D);
    }
void setup() { noStroke();
  textSize(32);
  textAlign(CENTER,CENTER);}

void draw() {
  
  background(200);
  lights();
  
  translate(width/2, height/2, 0);
   rotateX(rX);
   rotateY(rZ);
   noStroke();
    box(200, 200, 10);
    translate(100, 0, 0);    
  stroke(255, 0, 0);
  line(-300, 0, 0, 100, 0, 0);
  
  stroke(0, 255, 0);
  line(-100, -200, 0, -100, 200, 0);
  
  stroke(0, 0, 255);
  line(-100, 0, -150, -100, 0, 150);
  
  fill(255, 0, 0, 255);
   text("x", 10, -5, 0);
   
    fill(0, 255, 0, 255);
   text("y", 0, 0, 10);
   
     fill(0, 0, 255, 255);
   text("z", -100, 0, 10);
   
   fill(255, 255, 255, 255);

    
}

void mouseDragged() {
  
  if(pmouseX < mouseX && rZ < PI/3) { //<>//
    rZ = rZ + rapidity; //<>//
  }
  else if(pmouseX > mouseX && rZ > -PI/3) {
    rZ = rZ - rapidity;
  }
  
  if(pmouseY < mouseY && rX > (-PI/3 + PI/2)) {
    rX = rX - rapidity;
  }
  else if(pmouseY > mouseY && rX < (PI/3 + PI/2)) {
     rX = rX + rapidity;
  }
}
  
void mouseWheel(MouseEvent event) {
  if (event.getCount() > 0) {
    rapidity += 0.01;
  }
  if (event.getCount() < 0 && rapidity > 0.01) {
    rapidity -= 0.01;
  }
}
