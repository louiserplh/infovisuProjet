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
   rotateZ(rZ);
    box(200, 200, 10);
    translate(100, 0, 0);;
}

void mouseDragged() {
  
  if(pmouseY < mouseY) {
    if(rZ < PI/3) {
    rZ += 0.1;
    }
  }
  else if(pmouseY > mouseY) {
    if(rZ > -PI/3) {
      rZ -= 0.1;
    }
  }
  
  if(pmouseX < mouseX) {
    if(rX < PI/3) {
    rX += 0.1;
    }
  }
  else if(pmouseX > mouseX) {
    if(rX > -PI/3) {
      rX -= 0.1;
    }
  }
  
}
