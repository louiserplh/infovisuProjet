
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
  
  // constructeur de la sphere`
  Ball(Plateau monPlato){
    diametreSphere = 15 ; 
    
    location = new PVector(0, -(monPlato.thicc/2 + diametreSphere), 0);
    gravityForce = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }
  
  // methode pour mettre a jour les coordonnees de la sphere
  void update(Plateau monPlato){
    if (!appuierSurShift()){
      gravityForce.set(sin(monPlato.rotationZ)*gravityConst, 
                       0, //faudrait faire decoller la balle, mais je sais pas comment, oopsi
                       -sin(monPlato.rotationX)*gravityConst);
      velocity.add(gravityForce);
      
      // La friction qui s'applique sur la sphere
      PVector friction = velocity.copy();
      friction.mult(-1);
      friction.normalize(); 
      friction.mult(frictionMagnitude); 
      
      velocity.add(friction);
      location.add(velocity);
    }
  }
  
  // methode pour afficher la sphere
  void display(){
     noStroke(); 
     fill(25); 
     if (appuierSurShift()){
       translate(location.x, -(diametreSphere + monPlato.thicc), location.z);
       sphere(diametreSphere); 
     }
     else {
       translate(location.x, location.y, location.z);
       sphere(diametreSphere); 
     }
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
  
}
