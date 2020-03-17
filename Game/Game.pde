float rapidity = 0.02;
ArrayList<Cylindre> mesCylindres = new ArrayList<Cylindre>();

Ball maBoule ;
Plateau monPlato ; 

//taille de la fenetre
void settings() {
    fullScreen();
    size(displayWidth, displayHeight, P3D); 
}

void setup() { 
  noStroke();
  textSize(32);
  textAlign(CENTER,CENTER);
  monPlato = new Plateau();
  maBoule = new Ball(monPlato);  
}
  
void draw() {
  
   background(255);
  
   //debut dessin plateau
   monPlato.display(appuierSurShift(), mesCylindres);
   
   //debut dessin sphere
   pushMatrix();
   maBoule.update(monPlato);
   maBoule.checkEdges(monPlato); 
   maBoule.display();
   popMatrix();
   
   
   //axes
   stroke(255, 0, 0);
   line(-monPlato.size, 0, 0, monPlato.size, 0, 0);
  
   stroke(0, 255, 0);
   line(0, -monPlato.size, 0, 0, monPlato.size, 0);
  
   stroke(0, 0, 255);
   line(0, 0, -monPlato.size, 0, 0, monPlato.size);
   
  
   //texte relatif aux axes
   
   /*
   pushMatrix();
    
   fill(255, 0, 0, 255);
   text("x", 215, 0, 0);
   
   fill(0, 255, 0, 255);
   text("y", 0, 215, 0);
   
   fill(0, 0, 255, 255);
   text("z", 0, 0, 215);
   
   fill(255, 255, 255, 255);
   
   popMatrix(); 
  */
   
}

  boolean appuierSurShift(){
    return (keyPressed == true && keyCode == SHIFT); 
  }


    //rotation du plateau en fonction des axes
  void mouseDragged() { 
    
    if(pmouseX < mouseX && monPlato.rotationZ < PI/3) {
      monPlato.rotationZ = monPlato.rotationZ + rapidity; 
    }
    else if(pmouseX > mouseX && monPlato.rotationZ > -PI/3) {
      monPlato.rotationZ = monPlato.rotationZ - rapidity; 
    }
    
    if(pmouseY < mouseY && monPlato.rotationX > (-PI/3)) {
      monPlato.rotationX = monPlato.rotationX - rapidity; 
    }
    else if(pmouseY > mouseY && monPlato.rotationX < (PI/3)) {
      monPlato.rotationX = monPlato.rotationX + rapidity; }
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
  
     // rajouter un cylindre
  void mouseClicked() {
    if(appuierSurShift() && mouseX <= ((monPlato.size/2)+displayWidth/2) 
                         && mouseY <= ((monPlato.size/2)+displayHeight/2)
                         &&mouseX >= ((-monPlato.size/2)+displayWidth/2)
                         && mouseY >= (-(monPlato.size/2)+displayHeight/2)) {
      mesCylindres.add(new Cylindre(mouseX - displayWidth/2, mouseY - displayHeight/2, monPlato.thicc/2));
    }
  }
  
