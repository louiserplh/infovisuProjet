class ParticleSystem {
  
  PVector origin; // the origin of the system
  ArrayList<Cylindre> cylindres;
  Ball ball;
  Plateau plateau;
  float rayonCyl;
  
  ParticleSystem(PVector origin, Plateau plateau, Ball ball) {
    this.origin = origin.copy();
    cylindres = new ArrayList<Cylindre>();
    cylindres.add(new Cylindre(origin.x, origin.y, origin.z));
    this.plateau = plateau;
    this.ball = ball;
    this.rayonCyl = cylindres.get(0).rayonCyl;
  }
  
  void addParticle() {
    
    PVector center;
    int numAttempts = 100;

    for(int i=0; i<numAttempts; i++) {
    // Pick a cylinder and its center.
    int index = int(random(cylindres.size())); 
    center = cylindres.get(index).position.copy();
    
     // Try to add an adjacent cylinder.
    float angle = random(TWO_PI);
    
    center.x += sin(angle) * 2*rayonCyl; 
    center.z += cos(angle) * 2*rayonCyl; 
    
    Cylindre cyl = new Cylindre(center.x, 0, center.z);
    if(cyl.surLePlateau(plateau) && !cyl.chevauchement(cylindres, ball)){
      cylindres.add(cyl);
      break; 
    }
    
    
   }
 }
  
  
}
