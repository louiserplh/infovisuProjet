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
  void run(){
    if(mesCylindres.size() > 0) {
    
      mesCylindres.get(0).display();
      
      pushMatrix();
        translate(mesCylindres.get(0).position.x, 
                  -mesCylindres.get(0).hauteurCyl - plateau.thicc/2, 
                  mesCylindres.get(0).position.z);
        scale(50);
        rotateX(PI);
        shape(evil);
      popMatrix();
      
      if(ball.collisionCylindre(mesCylindres.get(0))){
        mesCylindres.clear();
      }
      
      for(int i=1; i<mesCylindres.size();++i){
        mesCylindres.get(i).display();
        if(ball.collisionCylindre(mesCylindres.get(i))){
            mesCylindres.remove(i);
        }
      }
     }
  }
}
