float depth = 2000;
float rX = 0;
float rZ = 0;
float rapidity = 0.02;
float gravityConstant = 1;

PVector gravityForce = new PVector(0, 0);
PVector location = new PVector(0, -25, 0);
PVector velocity = new PVector(1, 1);

void settings() {
    size(500, 500, P3D); //taille de la fenetre
}
void setup() { 
  noStroke();
  textSize(32);
  textAlign(CENTER,CENTER);
}
  
void draw() {
  
   background(200);
   
   //debut dessin plateau
   lights(); 
   translate(width/2, height/2, 0);
   rotateX(rX);
   rotateY(rZ);
   noStroke();
   box(200, 10, 200);
   //fin dessin plateau 
   
   //debut dessin sphere
   pushMatrix();
   
   translate(location.x, location.y, location.z);
   noStroke();
   sphere(20);
   
   popMatrix();
   //fin dessin sphere
   
   location.add(velocity);
   
   //axes
   stroke(255, 0, 0);
   line(-200, 0, 0, 200, 0, 0);
  
   stroke(0, 255, 0);
   line(0, -200, 0, 0, 200, 0);
  
   stroke(0, 0, 255);
   line(0, 0, -200, 0, 0, 200);
  
   //texte relatif aux axes
   pushMatrix();
   
   rotate(0); 
   fill(255, 0, 0, 255);
   text("x", 225, 0, 0);
   
   fill(0, 255, 0, 255);
   text("y", 0, 225, 0);
   
   fill(0, 0, 255, 255);
   text("z", 0, 0, 225);
   
   fill(255, 255, 255, 255);
   
   popMatrix();

    
}

void mouseDragged() { //rotation du plateau en fonction des axes
  
  if(pmouseX < mouseX && rZ < PI/3) { //<>//
    rZ = rZ + rapidity; //<>//
  }
  else if(pmouseX > mouseX && rZ > -PI/3) {
    rZ = rZ - rapidity;
  }
  
  if(pmouseY < mouseY && rX > (-PI/3)) {
    rX = rX - rapidity;
  }
  else if(pmouseY > mouseY && rX < (PI/3)) {
     rX = rX + rapidity;
  }
}
  
void mouseWheel(MouseEvent event) { // gérer la rapidité de la rotation
  if (event.getCount() > 0) {
    rapidity += 0.01;
  }
  if (event.getCount() < 0 && rapidity > 0.01) {
    rapidity -= 0.01;
  }
}
