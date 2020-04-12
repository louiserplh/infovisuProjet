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
  PGraphics scrollBar; 
  PGraphics victory;
  IntList rectanglesBarChart ;
  
  int strokeWeight = 6 ;
  
  float scrollBarWidth = width - 2*topViewSize - frameSize ;  //Bar's width in pixels
  float sliderPosition, newSliderPosition;    //Position of slider
  float sliderPositionMin = strokeWeight / 2 ;
  float sliderPositionMax = scrollBarWidth - scrollBarHeight;
  float currentSliderPosition ; 

  boolean timeReset2 = true ;
  
  float timeStart2 ; 
  float timeElapsed2 ; 
  
  final PVector color1 = new PVector(245, 237, 208) ;  //brun pastel 
  final PVector color2 = new PVector(255, 247, 218) ;  //brun pastel + clair
  final PVector color3 = new PVector(192, 186, 152) ;  //brun petant
  final PVector accentColor = new PVector(112, 182, 115) ; //vert
  
  
  PGraphiques(){
    gameSurface = createGraphics(width, height-topViewSize, P3D); 
    myBackground = createGraphics(width,topViewSize,P3D);
    topView = createGraphics(topViewSize  - frameSize, topViewSize  - frameSize,P2D);
    scoreBoard = createGraphics(topViewSize - frameSize, topViewSize - frameSize, P2D);
    barChart = createGraphics(width - 2*topViewSize - frameSize , topViewSize - scrollBarHeight - 2 * frameSize, P2D); 
    scrollBar = createGraphics(width - 2*topViewSize - frameSize, scrollBarHeight, P2D);
    sliderPosition = scrollBarWidth/2 - scrollBarHeight/2 ; 
    rectanglesBarChart = new IntList();
    rectanglesBarChart.append(0);
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
     topView.stroke(strokeWeight);
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
    scoreBoard.strokeWeight(strokeWeight);
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
    int oneSquareInPoints = 5 ; 
    int minDimX = 3 ; 
    float dimX = minDimX + 20 * currentSliderPosition  ; 
    int dimY = 5 ;
    
    barChart.beginDraw();
    barChart.fill(color2.x, color2.y, color2.z);
    barChart.stroke(accentColor.x, accentColor.y, accentColor.z);
    barChart.strokeWeight(strokeWeight);
    barChart.rect(0, 0, width - 2*topViewSize - frameSize, topViewSize - scrollBarHeight - 2 * frameSize);
    barChart.stroke(color3.x, color3.y, color3.z);
    barChart.strokeWeight(3);
    barChart.line(strokeWeight / 2, (topViewSize - scrollBarHeight - 2 * frameSize) / 2 , width - 2*topViewSize - frameSize - strokeWeight / 2, (topViewSize - scrollBarHeight - 2 * frameSize) / 2);
    
    //ajout d'un baton au barChart toutes les secondes
    if(wasInitialised && !partieFinie && !appuierSurShift()){
        if(timeReset2){
           timeStart2 = frameCount / frameRate;
           timeReset2 = false ;
         }
         
         timeElapsed2 = frameCount / frameRate - timeStart2 ;
         
         if(timeElapsed2 >= 1) {
           int squaresToAdd = round((abs(totalScore) / oneSquareInPoints)); 
           if(totalScore > 0){
             rectanglesBarChart.append(squaresToAdd) ;
           }else if(totalScore < 0){
             rectanglesBarChart.append(-squaresToAdd) ; 
           }else{
             rectanglesBarChart.append(0) ;
           }
            timeReset2 = true ;
         }         
    }
         
         for(int i = 0; i < rectanglesBarChart.size(); ++i){
            for(int j = 0; j < abs(rectanglesBarChart.get(i)); ++j){
              barChart.stroke(color2.x, color2.y, color2.z);
              barChart.strokeWeight(1);
              if(rectanglesBarChart.get(i) < 0 ){
                barChart.fill(accentColor.x, accentColor.y, accentColor.z - 10 * j) ;
                barChart.rect(strokeWeight/2 + i * dimX, (topViewSize - scrollBarHeight - 2 * frameSize) / 2 + j * dimY, dimX, dimY) ;
              }else {
                 barChart.fill(accentColor.x, accentColor.y, accentColor.z + 10 * j) ;
                 barChart.rect(strokeWeight/2 + i * dimX, (topViewSize - scrollBarHeight - 2 * frameSize) / 2  - j * dimY, dimX, dimY) ;
              }
            }
         }    
    barChart.endDraw();
  }
  
  
  void scrollBar(){
    boolean mouseOver ; 
    boolean locked = false ; 
    
    newSliderPosition = sliderPosition;
    
    
    if (mouseX > 2*topViewSize + frameSize/2 && mouseX < 2*topViewSize + frameSize/2 + scrollBarWidth &&
        mouseY > height - scrollBarHeight - frameSize / 2 && mouseY < height - frameSize / 2) {
      mouseOver = true;
    }else {
      mouseOver = false;
    }
    if (mousePressed && mouseOver) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderPosition = min(max(mouseX - scrollBarWidth/2 + scrollBarHeight / 2, sliderPositionMin), sliderPositionMax); //the constraint method ; 
    }
    if (abs(newSliderPosition - sliderPosition) > 1) {
      sliderPosition = newSliderPosition ;
    }
    
    scrollBar.beginDraw();
    scrollBar.stroke(accentColor.x, accentColor.y, accentColor.z);
    scrollBar.strokeWeight(strokeWeight); 
    scrollBar.fill(min(accentColor.x+35, 255), min(accentColor.y+35, 255), min(accentColor.z+35, 255));
    scrollBar.rect(0, 0, scrollBarWidth, scrollBarHeight);
    if (mouseOver || locked) {
     scrollBar.fill(color3.x, color3.y, color3.z);
    }
    else {
     scrollBar.fill(color1.x, color1.y, color1.z);
    }
    scrollBar.noStroke();
    scrollBar.rect(sliderPosition, strokeWeight/2, scrollBarHeight, scrollBarHeight - strokeWeight);
    scrollBar.endDraw();
     
    currentSliderPosition = (sliderPosition)/(scrollBarWidth - scrollBarHeight) ; 
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
        victory.clear();
      }
      
      // il reste a faire l'animation
   
      victory.endDraw(); 
    }    
  }*/
  
}
