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
 // PGraphics background;
  PGraphics topView;
  PGraphics scoreBoard;
  
  Ball maBoule;
  Plateau monPlato; 
  ParticleSystem cylindres;
  
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
    textSize(32);
    gameSurface = createGraphics(width, height-topViewSize, P3D); 
    //background = createGraphics(width,topViewSize,P3D);
    topView = createGraphics(topViewSize,topViewSize,P2D);
    scoreBoard = createGraphics(topViewSize - frameSize, topViewSize - frameSize, P2D);
    monPlato = new Plateau();
    maBoule = new Ball(monPlato);
    PImage img = loadImage("robotnik.png");
    evil = loadShape("robotnik.obj");
    evil.setTexture(img);
  }
   
  void draw() {
    drawGame();
    image(gameSurface, 0, 0);
    //image(background,0,height-topViewSize);
    topView();
    image(topView,0,height-topViewSize);
    scoreBoard();
    image(scoreBoard, topViewSize + frameSize/2, height-topViewSize + frameSize/2); 
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
          ajoutCylindre = cylindres.addParticle(appuierSurShift());
          timeReset = true ; 
        }
     
       // dessin des cylindres
       removeCylindre = cylindres.run(gameSurface);
    }
    
     // dessin sphere
     maBoule.update(monPlato);
     maBoule.checkEdges(monPlato);  
     maBoule.display(appuierSurShift(),gameSurface);
     gameSurface.endDraw();
     
     //background.beginDraw();
     //background.background(100);
     //background.endDraw();
  }
  
  void topView(){
    float ratio = topViewSize / monPlato.size ; 
     topView.beginDraw();
     topView.background(0, 105, 150); 
     topView.fill(255, 150, 0);
     topView.stroke(10);
     topView.circle(topViewSize/2 + (maBoule.location.x*ratio), topViewSize/2 + (maBoule.location.z*ratio), maBoule.diametreSphere);
     if(wasInitialised){
       for (int i = 0 ; i < cylindres.mesCylindres.size(); ++i) {
         Cylindre cyl = cylindres.mesCylindres.get(i);
        if(i == 0) {
           topView.fill(255, 0, 0);
           topView.stroke(255,200, 0);
           topView.circle(topViewSize/2 + (cyl.position.x*ratio), topViewSize/2 + (cyl.position.z*ratio), cyl.rayonCyl*2*ratio);
           
         }else{ 
           topView.fill(255);
           topView.noStroke();
           topView.circle(topViewSize/2 + (cyl.position.x*ratio), topViewSize/2 + (cyl.position.z*ratio), cyl.rayonCyl*2*ratio);
         }
       }
     }
    topView.endDraw(); 
  }
  
  void scoreBoard(){
    scoreBoard.beginDraw();
    scoreBoard.background(235);
    
    if(ajoutCylindre & timeReset){
      lastScore = -10 ;
      totalScore += lastScore ;
    }else if(removeCylindre){
      lastScore = int(5*maBoule.velocity.mag());
      totalScore += lastScore ;
    }
    scoreBoard.textSize(17.5);
    scoreBoard.fill(50);
    scoreBoard.text("Total Score :" , frameSize/2, topViewSize/9 );
    scoreBoard.text(totalScore , frameSize/2, 2*topViewSize/9 );
    scoreBoard.text("Velocity : " , frameSize/2, 4*topViewSize/9 );
    scoreBoard.text(maBoule.velocity.mag(), frameSize/2, 5*topViewSize/9 );
    scoreBoard.text("Last Score " , frameSize/2 , 7*topViewSize/9 );
    scoreBoard.text(lastScore , frameSize/2 , 8*topViewSize/9 );
   
    scoreBoard.endDraw();
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
    
    
