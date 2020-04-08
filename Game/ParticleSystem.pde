  /*
  *  ParticleSystem.pde  
  *  Classe pour gerer la creation des particules dans le jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */


class ParticleSystem {
  
  PVector origin;  // Origine du systeme
  ArrayList<Cylindre> mesCylindres;
  Ball ball;
  Plateau plateau;
  float rayonCyl;
  PShape evil;    // Forme pour le mechant du jeu
  
  // constructeur dy systeme de particules
  ParticleSystem(PVector origin, Plateau plateau, Ball ball, PShape evil) {
    this.origin = origin.copy();
    mesCylindres = new ArrayList<Cylindre>();
    mesCylindres.add(new Cylindre(origin.x, origin.y, origin.z));
    this.plateau = plateau;
    this.ball = ball;
    this.rayonCyl = mesCylindres.get(0).rayonCyl;
    this.evil = evil;
  }
  
  // methode pour ajouter des particules
  void addParticle(boolean appuierSurShift) {
    
    if(mesCylindres.size() > 0) {
      if(!appuierSurShift) {
        PVector center;
        int numAttempts = 1000;
  
        for(int i=0; i<numAttempts; i++) {
        
          int index = int(random(mesCylindres.size()));    // Choix de l'origine d'un cylindre au hasard
          center = mesCylindres.get(index).position.copy();
          
          float angle = random(TWO_PI);                    // Choix d'un angle au hasard pour ajouter une particule  
          center.x += sin(angle) * 2*rayonCyl; 
          center.z += cos(angle) * 2*rayonCyl; 
          
          Cylindre cyl = new Cylindre(center.x, origin.y, center.z);
          if(cyl.surLePlateau(plateau) && !cyl.chevauchement(mesCylindres, ball)){
            mesCylindres.add(cyl);
            i = numAttempts; 
          } 
        }
      }
    }
 }
 
  // methode pour mettre faire tourner le systeme de gestion des particules 
  void run(PGraphics pg){
    //pg.beginDraw();
    if(mesCylindres.size() > 0) {
    
      mesCylindres.get(0).display(pg);
      
      pg.pushMatrix();
        float angle = atan2(mesCylindres.get(0).position.z - ball.location.z , mesCylindres.get(0).position.x - ball.location.x ); // angle entre la sphere et le mechant
        pg.translate(mesCylindres.get(0).position.x, 
                  -mesCylindres.get(0).hauteurCyl - plateau.thicc/2, 
                  mesCylindres.get(0).position.z);
        pg.scale(50);
        pg.rotateX(PI);
        pg.rotateY(angle - PI/2); // rotation de Y pour que le mechant regarde la sphere en tout temps 
        pg.shape(evil);
      pg.popMatrix();
      
      if(ball.collisionCylindre(mesCylindres.get(0))){
        mesCylindres.clear();
      }
      
      for(int i=1; i<mesCylindres.size();++i){
        mesCylindres.get(i).display(pg);
        if(ball.collisionCylindre(mesCylindres.get(i))){
            mesCylindres.remove(i);
        }
      }
     }
     //pg.endDraw();
  }
}
