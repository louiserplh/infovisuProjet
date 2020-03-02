float depth = 2000;
float rX = PI/2;
float rZ = PI/2;
void settings() {
      size(500, 500, P3D);
    }
void setup() { noStroke(); }

void draw() {
  
  background(200);
  lights();
  translate(width/2, height/2, 0);
   rotateX(rX);
   rotateY(rZ);
    box(200, 200, 10);
    translate(100, 0, 0);;
}

void mouseDragged() {
  
  if(pmouseX < mouseX) { //<>//
    float temp = rZ + 0.1; //<>//
    if(temp > PI/3) {
    rZ = PI/3;
    }
    else {
      rZ = temp;
    }
  }
  else if(pmouseX > mouseX) {
    float temp = rZ - 0.1;
    if(temp < -PI/3) {
      rZ = -PI/3;
    }
    else {
      rZ = temp;
    }
  }
  
  if(pmouseY < mouseY) {
    float temp = rX - 0.1;
    if(temp < -PI/3) {
    rX -= PI/3;
    }
    else {
      rX = temp;
    }
  }
  else if(pmouseY > mouseY) {
     float temp = rX + 0.1;
    if(temp > PI/3) {
      rX = PI/3;
    }
    else {
      rX = temp;
    }
  }
}
