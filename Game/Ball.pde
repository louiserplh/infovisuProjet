
class Ball {
  
  PVector gravityForce ;
  PVector location ;
  PVector velocity ;
  final int diametreSphere ; //diametre de la sphere 
  final float gravityConst = 0.4 ; // constante de la gravitation
  final float coefRebon = 0.5 ; // coefficient de rebond
  
  final float normalForce = 1;
  final float mu = 0.05; // coeff de friction
  float frictionMagnitude = normalForce * mu;
  
  boolean enContact = false;
  
  Plateau plato;
  
  // constructeur de la sphere`
  Ball(Plateau monPlato){
    diametreSphere = 15 ; 
    plato = monPlato;
    
    location = new PVector(0, -(monPlato.thicc/2 + diametreSphere), 0);
    gravityForce = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }
  
  // methode pour mettre a jour les coordonnees de la sphere
  void update(Plateau monPlato){
    if (!appuierSurShift()){
      // La friction qui s'applique sur la sphere
      PVector friction = velocity.copy();
      friction.mult(-1);
      friction.normalize(); 
      friction.mult(frictionMagnitude); 
      
      gravityForce.set(sin(monPlato.rotationZ)*gravityConst, 
                       0, //faudrait faire decoller la balle, mais je sais pas comment, oopsi
                       -sin(monPlato.rotationX)*gravityConst);

      velocity.add(gravityForce);
      velocity.add(friction);
      location.add(velocity);
      
    }
  }
  
  // methode pour afficher la sphere
  void display(boolean appuierSurShift){
    pushMatrix();
     noStroke(); 
     fill(25); 
     if (appuierSurShift){
       translate(location.x, -(diametreSphere + monPlato.thicc), location.z);
       sphere(diametreSphere); 
     }
     else {
       translate(location.x, location.y, location.z);
       sphere(diametreSphere); 
     }
    popMatrix();
  }
  
  // methode pour eviter que la sphere parte hors du plateau  
  void checkEdges(Plateau monPlato){
      if(location.x > ((monPlato.size/2)-diametreSphere)) {
         velocity.x = velocity.x * -coefRebon;
         location.x = ((monPlato.size)/2-diametreSphere);
       } 
       else if(location.x < -((monPlato.size)/2-diametreSphere)){
         velocity.x = (velocity.x * -coefRebon);
         location.x = -((monPlato.size)/2-diametreSphere);
       }
       
       if(location.z > ((monPlato.size)/2-diametreSphere)) {
         velocity.z = velocity.z * -coefRebon;
         location.z = ((monPlato.size)/2-diametreSphere);
       } 
       else if(location.z < -((monPlato.size)/2-diametreSphere)){
         velocity.z = velocity.z * -coefRebon;
         location.z = -((monPlato.size)/2-diametreSphere);
       }
  }
  
  // methode pour eviter que la balle entre dans les cylindres
  void collisionCylindre(ArrayList<Cylindre> mesCylindres){
     
    for (int i = 0 ; i < mesCylindres.size(); ++i) {
         
       Cylindre monCylindre = mesCylindres.get(i);
       
       //vecteur avec la distance entre la balle et le cylindre pour x et z (on s'en fiche de y)
       PVector vectDistance = new PVector (location.x - monCylindre.position.x, 0, location.z - monCylindre.position.z);
       //valeur numerique de la distance
       float distance = vectDistance.mag(); 
       
         // reaction a la collision : calcul du vecteur normal
        PVector vectNormal = new PVector(location.x - monCylindre.position.x, 0, location.z - monCylindre.position.z).normalize(); 
          
        float angleSep = PVector.angleBetween(vectNormal, velocity); // angle between normal vector and velocity
        PVector pos = monCylindre.position;
 
       // savoir si la sphere entre en collision
       if(distance <= (diametreSphere + monCylindre.rayonCyl) && angleSep >= PI/2){
         
        velocity = PVector.sub(velocity, vectNormal.mult(2 * PVector.dot(velocity, vectNormal))) ; 
        location.x = pos.x + (diametreSphere + monCylindre.rayonCyl) ;
        location.z = pos.z + (diametreSphere + monCylindre.rayonCyl);
        
     }
    }
  }
}
