float rapidity = 0.02;


Ball maBoule;
Plateau monPlato; 
ParticleSystem cylindres;

boolean wasInitialised = false;

//taille de la fenetre
void settings() {
    fullScreen();
    size(displayWidth, displayHeight, P3D); 
}

void setup() { 
  textSize(32);
  monPlato = new Plateau();
  maBoule = new Ball(monPlato); 
}
  
void draw() {
  
   background(255);
 
   //debut dessin plateau
   monPlato.display(appuierSurShift());
   
   
   if(wasInitialised) {
  float deciSeconds = (frameCount/frameRate) * 10;
  if(int(deciSeconds) % 5 == 0) {
    cylindres.addParticle();
  }
   
   //dessin cylindre
   for (int i = 0 ; i < cylindres.mesCylindres.size(); ++i) {
       pushMatrix();
       cylindres.run();
       popMatrix();
   }
   }
  
   //debut dessin sphere
   pushMatrix();
   maBoule.update(monPlato);
   maBoule.checkEdges(monPlato);  
   //maBoule.collisionCylindre(cylindres.mesCylindres);
   maBoule.display(appuierSurShift());
   popMatrix();
      
}


  // detetcte si on appuye sur la touche Shift
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
    if(appuierSurShift()) {
      
      PVector origin = new PVector(mouseX - displayWidth / 2,
                                   -50 - monPlato.thicc/2,
                                   mouseY - displayHeight / 2);
      cylindres = new ParticleSystem(origin, monPlato, maBoule);
      wasInitialised = true;
      
      /**
        Cylindre cylindre = new Cylindre(mouseX - displayWidth / 2, 0, mouseY - displayHeight / 2);
        cylindre.position.y = -cylindre.hauteurCyl - monPlato.thicc/2;
        if(!cylindre.chevauchement(mesCylindres, maBoule) && cylindre.surLePlateau(monPlato)) {
        mesCylindres.add(cylindre);
        **/
        }
    }
  
  
