  Ball maBoule;
  Plateau monPlato; 
  ParticleSystem cylindres;
  PShape evil;
  float timeStart ; 
  float timeElapsed ; 
  
  float rapidity = 0.02;
  
  boolean timeReset = true ;
  boolean wasInitialised = false;
  
  // taille de la fenetre
  void settings() {
      fullScreen();
      size(displayWidth, displayHeight, P3D); 
  }
  
  // initialisation des elements de jeu
  void setup() { 
    textSize(32);
    monPlato = new Plateau();
    maBoule = new Ball(monPlato);
    PImage img = loadImage("robotnik.png");
    evil = loadShape("robotnik.obj");
    evil.setTexture(img);
  }
   
  void draw() {
    
     background(255);
   
     // dessin plateau
     monPlato.display(appuierSurShift());
     
     if(wasInitialised) {
       if(timeReset){
         timeStart = frameCount / frameRate;
         timeReset = false ;
       }
       
       timeElapsed = frameCount / frameRate - timeStart ;
     
       //ajout de cylindres toutes les demies secondes
       if(timeElapsed >= 0.5) {
          cylindres.addParticle(appuierSurShift());
          timeReset = true ; 
        }
     
       // dessin des cylindres
       for (int i = 0 ; i < cylindres.mesCylindres.size(); ++i) {
           cylindres.run();
         }
     }
    
     // dessin sphere
     maBoule.update(monPlato);
     maBoule.checkEdges(monPlato);  
     maBoule.display(appuierSurShift());
  }
  
  
    // detetcte si on appuye sur la touche Shift
    boolean appuierSurShift(){
      return (keyPressed == true && keyCode == SHIFT); 
    }
  
    // rotation du plateau en fonction des axes
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
      
      if (event.getCount() > 0 && rapidity < 0.2) {
        rapidity += 0.01;
      }
      if (event.getCount() < 0 && rapidity > 0.01) {
        rapidity -= 0.01;
      }
    }
                           
    // rajouter le cylindre initial
    void mouseClicked() {
      if(appuierSurShift()) {
        
        PVector origin = new PVector(mouseX - displayWidth / 2,
                                     -50 - monPlato.thicc/2,
                                     mouseY - displayHeight / 2);
        if(monPlato.surLePlateau(origin)) {        
          cylindres = new ParticleSystem(origin, monPlato, maBoule,evil);
          wasInitialised = true;
        }
      }
    }  
    
    
