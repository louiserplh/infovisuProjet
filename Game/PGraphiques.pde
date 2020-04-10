/*
  *  PGraphiques.pde  
  *  Classe pour gerer les affichages graphiques dans le jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */
  

class PGraphiques {
  
  PGraphics gameSurface; 
  PGraphics myBackground;
  PGraphics topView;
  PGraphics scoreBoard;
  PGraphics barChart; 
  PGraphics victory;
  
  boolean timeReset2 = true ;
  
  float timeStart2 ; 
  float timeElapsed2 ; 
  
  final PVector color1 = new PVector(245, 237, 208) ;  //brun pastel 
  final PVector color2 = new PVector(255, 247, 218) ;  //brun pastel + clair
  final PVector color3 = new PVector(192, 186, 152) ;  //brun petant
  final PVector accentColor = new PVector(112, 182, 73) ; //vert
  
  
  PGraphiques(){
    gameSurface = createGraphics(width, height-topViewSize, P3D); 
    myBackground = createGraphics(width,topViewSize,P3D);
    topView = createGraphics(topViewSize  - frameSize, topViewSize  - frameSize,P2D);
    scoreBoard = createGraphics(topViewSize - frameSize, topViewSize - frameSize, P2D);
    barChart = createGraphics(width - 2*topViewSize - frameSize , topViewSize - frameSize, P2D); 
    victory = createGraphics(width , height, P2D);
  }
  
  //methode pour l'affichage de la plage graphique pour le jeu
  void drawGame(){
      gameSurface.beginDraw();
      gameSurface.background(250);
   
     // dessin plateau
      monPlato.display(appuierSurShift(), gameSurface, accentColor);
     
     if(wasInitialised) {
       if(timeReset){
         timeStart = frameCount / frameRate;
         timeReset = false ;
       }
       
       timeElapsed = frameCount / frameRate - timeStart ;
     
       //ajout de cylindres toutes les demies secondes
       if(timeElapsed >= 0.5) {
          ajoutCylindre = cylindres.addParticle(appuierSurShift(), accentColor );
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
     
  }
  
  void myBackground(){
    myBackground.beginDraw();
    myBackground.background(color1.x, color1.y, color1.z);
    myBackground.endDraw();
  }
  
  //methode pour l'affichage de la plage graphique du terrain (vue aerienne)
  void topView(){
    float ratio = (topViewSize - frameSize) / monPlato.size ; 
     topView.beginDraw();
     topView.background(accentColor.x, accentColor.y, accentColor.z); 
     topView.fill(color3.x, color3.y, color3.z);
     topView.stroke(10);
     topView.circle((topViewSize - frameSize)/2 + (maBoule.location.x*ratio), (topViewSize - frameSize)/2 + (maBoule.location.z*ratio), maBoule.diametreSphere*ratio);
     if(wasInitialised){
       for (int i = 0 ; i < cylindres.mesCylindres.size(); ++i) {
         Cylindre cyl = cylindres.mesCylindres.get(i);
        if(i == 0) {
           topView.fill(255, 0, 0);
           topView.stroke(255);
           topView.circle((topViewSize - frameSize)/2 + (cyl.position.x*ratio), (topViewSize - frameSize)/2 + (cyl.position.z*ratio), cyl.rayonCyl*2*ratio);
         }else{ 
           topView.fill(color1.x, color1.y, color1.z);
           topView.noStroke();
           topView.circle((topViewSize - frameSize)/2 + (cyl.position.x*ratio), (topViewSize - frameSize)/2 + (cyl.position.z*ratio), cyl.rayonCyl*2*ratio);
         }
       }
     }
    topView.endDraw(); 
  }
  
  //methode pour l'affichage de la plage graphique pour le tableau de score
  void scoreBoard(){
    scoreBoard.beginDraw();
    scoreBoard.fill(color1.x, color1.y, color1.z);
    scoreBoard.stroke(accentColor.x, accentColor.y, accentColor.z);
    scoreBoard.strokeWeight(8);
    scoreBoard.rect(0, 0, topViewSize - frameSize, topViewSize - frameSize);
    float velocity = round(10 * maBoule.velocity.mag()) / 10.0 ; 
    
    if(ajoutCylindre & timeReset){
      lastScore = -10 ;
      totalScore += lastScore ;
    }else if(removeCylindre){
      lastScore = round(5 * velocity);
      totalScore += lastScore ;
    }
    
    scoreBoard.textSize(20);
    scoreBoard.fill(accentColor.x, accentColor.y, accentColor.z);
    scoreBoard.text("Total Score :" , frameSize, topViewSize/9 );
    scoreBoard.text(totalScore , frameSize, 2*topViewSize/9 );
    scoreBoard.text("Velocity : " , frameSize, 4*topViewSize/9 );
    scoreBoard.text(velocity, frameSize, 5*topViewSize/9 );
    scoreBoard.text("Last Score " , frameSize , 7*topViewSize/9 );
    scoreBoard.text(lastScore , frameSize , 8*topViewSize/9 );
   
    scoreBoard.endDraw();
  }
  
  //methode pour l'affichage de la plage graphique du graphique en batons
  void barChart(){
    int elapsedSeconds = 0 ;
    int positionY = 0 ; 
    
    barChart.beginDraw();
    barChart.fill(color2.x, color2.y, color2.z);
    barChart.stroke(accentColor.x, accentColor.y, accentColor.z);
    barChart.strokeWeight(8);
    barChart.rect(0, 0, width - 2*topViewSize - frameSize, topViewSize - frameSize);
    barChart.stroke(color3.x, color3.y, color3.z);
    barChart.strokeWeight(3);
    barChart.line(4, topViewSize / 3, width - 2*topViewSize - frameSize - 4, topViewSize / 3);
    
    barChart.fill(accentColor.x, accentColor.y, accentColor.z) ;
    barChart.stroke(color2.x, color2.y, color2.z);
    barChart.strokeWeight(1);
    barChart.rect(4 + elapsedSeconds,        //origine x du rectangle
                  topViewSize/3 + positionY*5,   //origine y du rectangle
                  10,                  
                  5);                
   
    
    if(wasInitialised){
      if(!partieFinie){
        if(timeReset2){
           timeStart2 = frameCount / frameRate;
           timeReset2 = false ;
         }
         timeElapsed2 = frameCount / frameRate - timeStart2 ;
         
         //ajout d'un baton au barChart toutes les secondes
         if(timeElapsed2 >= 1) {
           positionY = 0 ;
           if(totalScore < 0 ){
             for(int i = 0 ; i > totalScore ; --i){
               positionY += 1 ;
             }
           }else if(totalScore > 0 ){      
             positionY -= 1 ; 
           }else {
           }
           elapsedSeconds += 10 ; 
           timeReset2 = true ; 
          }
      }
    }
    barChart.endDraw();
  }
  
  
  /*void victory(){
    
    if(partieFinie){
      victory.beginDraw();
      victory.background(0);
      victory.textSize(50); 
      victory.fill(color1.x, color1.y, color1.z); 
      victory.text("You won !", 850, 100);
      victory.textSize(25);
      victory.text("[press control to continue playing]", 750, 150); 
      if(appuierSurCtrl()){
        partieFinie = false ; 
      }
      victory.endDraw(); 
    }    
  }*/


}
