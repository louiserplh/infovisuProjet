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
  ArrayList<Rectangles> rectanglesBarChart ; 

  
  boolean timeReset2 = true ;
  
  float timeStart2 ; 
  float timeElapsed2 ; 
  
  final PVector color1 = new PVector(245, 237, 208) ;  //brun pastel 
  final PVector color2 = new PVector(255, 247, 218) ;  //brun pastel + clair
  final PVector color3 = new PVector(192, 186, 152) ;  //brun petant
  final PVector accentColor = new PVector(112, 182, 73) ; //vert
  
  
  PGraphiques(){
    ArrayList<Rectangles> rectanglesBarChart = new ArrayList<Rectangles>();
    rectanglesBarChart.add(new Rectangles(0, 0, 0, 0, 0)) ;
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
    int origineY ; 
    int dimX = 10 ; 
    int dimY = 5 ;
    int fade = 5; 
    Rectangles rect ;
    
    barChart.beginDraw();
    barChart.fill(color2.x, color2.y, color2.z);
    barChart.stroke(accentColor.x, accentColor.y, accentColor.z);
    barChart.strokeWeight(8);
    barChart.rect(0, 0, width - 2*topViewSize - frameSize, topViewSize - frameSize);
    barChart.stroke(color3.x, color3.y, color3.z);
    barChart.strokeWeight(3);
    barChart.line(4, topViewSize / 3, width - 2*topViewSize - frameSize - 4, topViewSize / 3);
    
    //ajout d'un baton au barChart toutes les secondes
    if(wasInitialised && !partieFinie){
        if(timeReset2){
           timeStart2 = frameCount / frameRate;
           timeReset2 = false ;
         }
         
         timeElapsed2 = frameCount / frameRate - timeStart2 ;
         
         if(timeElapsed2 >= 1) {
           origineY = 0 ; 
           if(totalScore < 0 ){
             for(int i = 0 ; i > totalScore ; --i){
               rect = new Rectangles(4 + elapsedSeconds * dimX, topViewSize/3 + origineY * dimY, dimX, dimY, fade * origineY ) ;
               rectanglesBarChart.add(rect);
               origineY += 1 ; 
             }
           }else if(totalScore > 0 ){ 
             for(int i = 0 ; i > totalScore ; ++i){
               rect = new Rectangles(4 + elapsedSeconds * dimX, topViewSize/3 + origineY * dimY, dimX, dimY, fade * origineY ) ;
               rectanglesBarChart.add(rect);
               origineY -= 1 ; 
             }
           }
           
           elapsedSeconds += 1 ; 
           timeReset2 = true ;
         }
    /*for(int i=0; i < rectanglesBarChart.size(); ++i){
       rectanglesBarChart.get(i).display(barChart, accentColor, color2);
    }*/
    }
    
   
    
    if(partieFinie){
      barChart.clear();
    }
    
    barChart.endDraw();
  }
  
  
  void victory(){
    
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
        victory.clear();
      }
      
      // il reste a faire l'animation
   
      victory.endDraw(); 
    }    
  }


}




class Rectangles{
  PVector origine ; 
  PVector dimension ;  
  int  myFade ; 
  
  Rectangles(float x, float y, float dimX, float dimY, int fade){
    myFade = fade ; 
    dimension = new PVector(dimX, dimY);
    origine = new PVector(x, y);
  }
    
  void display(PGraphics barChart, PVector colorShade, PVector color2){
    barChart.pushMatrix(); 
    
    if(colorShade.z - myFade <= 255 && colorShade.z - myFade >= 0 ){
      fill(colorShade.x, colorShade.y, colorShade.z - myFade) ; 
    }else if(colorShade.z - myFade > 255){
      fill(colorShade.x, colorShade.y, 255) ; 
    }else if(colorShade.z - myFade < 0){
        fill(colorShade.x, colorShade.y, 0) ; 
    }
    stroke(color2.x, color2.y, color2.z);
    strokeWeight(1);
    
    barChart.rect(origine.x, origine.y, dimension.x, dimension.y); 
    barChart.popMatrix();
  } 
}
