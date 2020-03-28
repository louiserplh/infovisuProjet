class ParticleSystem {
  
  PVector origin; // the origin of the system
  ArrayList<Cylindre> mesCylindres;
  Ball ball;
  Plateau plateau;
  float rayonCyl;
  PShape evil;
  
  ParticleSystem(PVector origin, Plateau plateau, Ball ball,PShape evil) {
    this.origin = origin.copy();
    mesCylindres = new ArrayList<Cylindre>();
    mesCylindres.add(new Cylindre(origin.x, origin.y, origin.z));
    this.plateau = plateau;
    this.ball = ball;
    this.rayonCyl = mesCylindres.get(0).rayonCyl;
    this.evil = evil;
  }
  
  void addParticle() {
    
    PVector center;
    int numAttempts = 100;

    for(int i=0; i<numAttempts; i++) {
    // Pick a cylinder and its center.
    int index = int(random(mesCylindres.size())); 
    center = mesCylindres.get(index).position.copy();
    
     // Try to add an adjacent cylinder.
    float angle = random(TWO_PI);
    
    center.x += sin(angle) * 2*rayonCyl; 
    center.z += cos(angle) * 2*rayonCyl; 
    
    Cylindre cyl = new Cylindre(center.x, origin.y, center.z);
    if(cyl.surLePlateau(plateau) && !cyl.chevauchement(mesCylindres, ball)){
      mesCylindres.add(cyl);
      break; 
    } 
  }
 }
  void run(){
    
    mesCylindres.get(0).display();
    shape(evil,origin.x,origin.y);
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
