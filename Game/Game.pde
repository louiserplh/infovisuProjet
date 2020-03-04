float depth = 2000;
float rX = PI/2;
float rZ = 0;
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
    translate(100, 0, 0);
}

void mouseDragged() {
  
  if(pmouseX < mouseX && rZ < PI/3) { //<>//
    rZ = rZ + 0.1; //<>//
  }
  else if(pmouseX > mouseX && rZ > -PI/3) {
    rZ = rZ - 0.1;
  }
  
  if(pmouseY < mouseY && rX > (-PI/3 + PI/2)) {
    rX = rX - 0.1;
  }
  else if(pmouseY > mouseY && rX < (PI/3 + PI/2)) {
     rX = rX + 0.1;
  }
}
