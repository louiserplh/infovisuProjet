  /*
  *  Game.pde  
  *  Classe principale du jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */
 
  
  PShape evil;
  PGraphics gameSurface; 
  PGraphics background;
  PGraphics topView;
  
  Ball maBoule;
  Plateau monPlato; 
  ParticleSystem cylindres;
  
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
    gameSurface = createGraphics(width, height-300, P3D); 
    background = createGraphics(width,300,P3D);
    topView = createGraphics(300,300,P2D);
    monPlato = new Plateau();
    maBoule = new Ball(monPlato);
    PImage img = loadImage("robotnik.png");
    evil = loadShape("robotnik.obj");
    evil.setTexture(img);
  }
   
  void draw() {
    drawGame();
    image(gameSurface, 0, 0);
    image(background,0,height-300);
    image(topView,0,height-300);
  }
  
  void drawGame(){
      
      gameSurface.beginDraw();
      gameSurface.background(255);
   
     // dessin plateau
      monPlato.display(appuierSurShift(), gameSurface);
     
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
           cylindres.run(gameSurface);
       }
     }
    
     // dessin sphere
     maBoule.update(monPlato);
     maBoule.checkEdges(monPlato);  
     maBoule.display(appuierSurShift(),gameSurface);
     gameSurface.endDraw();
     
     background.beginDraw();
     background.background(100);
     background.endDraw();
     
     topView.beginDraw();
     topView.background(50);
     topView.endDraw();
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
    
    
