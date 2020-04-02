  /*
  *  Ball.pde  
  *  Classe pour gerer la balle dans le jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */
  

class Ball {
  
  PVector gravityForce ;
  PVector location ;
  PVector velocity ;
  PShape sphere ; 
  final int diametreSphere ; //diametre de la sphere 
  final float gravityConst = 0.4 ; // constante de la gravitation
  final float coefRebon = 0.5 ; // coefficient de rebond
  
  final float normalForce = 1; // froce normale
  final float mu = 0.05; // coeff de friction
  float frictionMagnitude = normalForce * mu;
  
  boolean enContact = false;
 
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
      // La friction qui s'applique sur la sphere
      PVector friction = velocity.copy();
      friction.mult(-1);
      friction.normalize(); 
      friction.mult(frictionMagnitude); 
      
      gravityForce.set(sin(monPlato.rotationZ)*gravityConst, 
                       0,
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
     fill(255); 
     PImage beachball = loadImage("BeachBall.png");
     float angle = atan2(location.z, -location.x);
     
     if (appuierSurShift){
       translate(location.x, -(diametreSphere + monPlato.thicc), location.z);
       sphere = createShape(SPHERE, diametreSphere); 
       sphere.setTexture(beachball);
       shape(sphere);
     }
     else {
       translate(location.x, location.y, location.z);
       sphere = createShape(SPHERE, diametreSphere); 
       sphere.setTexture(beachball);
       rotate(angle*PI);
       shape(sphere);
     }
    popMatrix();
  }
  
  // methode pour eviter que la sphere sorte hors du plateau  
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
  boolean collisionCylindre(Cylindre monCylindre){
      
       PVector vectDistance = new PVector (location.x - monCylindre.position.x, 0, location.z - monCylindre.position.z);           //Vecteur avec la distance entre la balle et le cylindre pour x et z 
       float distance = vectDistance.mag();                                                                                        //Valeur numerique de la distance
       PVector vectNormal = new PVector(location.x - monCylindre.position.x, 0, location.z - monCylindre.position.z).normalize();  //Reaction a la collision : calcul du vecteur normal        
       float angleSep = PVector.angleBetween(vectNormal, velocity);                                                                //Angle entre le veteur normal et la velocity
 
       // savoir si la sphere entre en collision
       if(distance <= (diametreSphere + monCylindre.rayonCyl) && angleSep >= PI/2){
        velocity = PVector.sub(velocity, vectNormal.mult(2 * PVector.dot(velocity, vectNormal))) ; 
        return true;
     }
     return false;
  }
}
