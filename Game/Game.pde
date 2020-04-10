  /*
  *  Game.pde  
  *  Classe principale du jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */
 
  
  PShape evil;
  
  Ball maBoule;
  Plateau monPlato; 
  ParticleSystem cylindres;
  PGraphiques affichage ; 
  
  float timeStart ; 
  float timeElapsed ; 
  float rapidity = 0.02;
  
  int topViewSize = 300 ;
  int frameSize = 20 ; 
  int lastScore = 0 ; 
  int totalScore = 0 ; 
  
  boolean timeReset = true ;
  boolean wasInitialised = false;
  boolean ajoutCylindre ; 
  boolean removeCylindre ;
  
  // taille de la fenetre
  void settings() {
      fullScreen();
      size(displayWidth, displayHeight, P3D); 
  }
  
  // initialisation des elements de jeu
  void setup() {     
    affichage = new PGraphiques();
    monPlato = new Plateau();
    maBoule = new Ball(monPlato);
    PImage img = loadImage("robotnik.png");
    evil = loadShape("robotnik.obj");
    evil.setTexture(img);
  }
   
  void draw() {
    affichage.drawGame();
    image(affichage.gameSurface, 0, 0);
    affichage.myBackground();
    image(affichage.myBackground,0,height-topViewSize);
    affichage.topView();
    image(affichage.topView, frameSize/2 ,height-topViewSize + frameSize/2);
    affichage.scoreBoard();
    image(affichage.scoreBoard, topViewSize + frameSize/2, height-topViewSize + frameSize/2); 
    affichage.barChart();
    image(affichage.barChart, 2*topViewSize + frameSize/2 , height-topViewSize + frameSize/2); 
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
          cylindres = new ParticleSystem(origin, monPlato, maBoule, evil, affichage.accentColor);
          wasInitialised = true;
        }
      }
    }  
    
    
