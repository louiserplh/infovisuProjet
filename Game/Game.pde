float depth = 2000;
float rX = 0;
float rZ = 0;
float rapidity = 0.05;
Ball maBoule = new Ball();

//taille de la fenetre
void settings() {
    size(500, 500, P3D); 
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
   rotateZ(rZ);
   noStroke();
   box(200, 10, 200);
   //fin dessin plateau 
   
   //debut dessin sphere
   //pushMatrix();
  
   maBoule.update();
   maBoule.display();
   maBoule.checkEdges(); 
   //popMatrix();
   //fin dessin sphere
   
   
   //axes
   stroke(255, 0, 0);
   line(-200, 0, 0, 200, 0, 0);
  
   stroke(0, 255, 0);
   line(0, -200, 0, 0, 200, 0);
  
   stroke(0, 0, 255);
   line(0, 0, -200, 0, 0, 200);
   
  
   //texte relatif aux axes
   pushMatrix();
    
   fill(255, 0, 0, 255);
   text("x", 215, 0, 0);
   
   fill(0, 255, 0, 255);
   text("y", 0, 215, 0);
   
   fill(0, 0, 255, 255);
   text("z", 0, 0, 215);
   
   fill(255, 255, 255, 255);
   
   popMatrix();

    
}

  //rotation du plateau en fonction des axes
void mouseDragged() { 
  
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


  // gérer la rapidité de la rotation
void mouseWheel(MouseEvent event) { 
  
  if (event.getCount() > 0) {
    rapidity += 0.01;
  }
  if (event.getCount() < 0 && rapidity > 0.01) {
    rapidity -= 0.01;
  }
}
