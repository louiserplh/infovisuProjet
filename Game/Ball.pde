
class Ball {
  
  PVector gravityForce ;
  PVector location ;
  PVector velocity ;
  final int diametreSphere ; //diametre de la sphere 
  final int rayonSphere ; // rayon de la sphere
  final float gravityConst = 0.8 ; // constante de la gravitation
  final float coefRebon = 0.5 ; // coefficient de rebond
  
  Ball(Plateau monPlato){
    diametreSphere = 10 ; 
    rayonSphere = diametreSphere/2 ;
    
    location = new PVector(0, -(monPlato.thicc + rayonSphere), 0);
    gravityForce = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }
  
  
  void update(Plateau monPlato){
    gravityForce.set(sin(monPlato.rotationZ)*gravityConst, 0, -sin(monPlato.rotationX)*gravityConst);
    velocity.add(gravityForce);
    location.add(velocity);
  }
  
  void display(){
     noStroke(); 
     fill(50); 
     translate(location.x, location.y, location.z);
     sphere(diametreSphere); 
  }
  
  void checkEdges(Plateau monPlato){
      if(location.x > (monPlato.size)/2-rayonSphere) {
         velocity.x = velocity.x * -coefRebon;
         location.x = ((monPlato.size)/2-rayonSphere);
       } 
       else if(location.x < -((monPlato.size)/2-rayonSphere)){
         velocity.x = velocity.x * -coefRebon;
         location.x = -((monPlato.size)/2-rayonSphere);
       }
       if(location.z > ((monPlato.size)/2-rayonSphere)) {
         velocity.z = velocity.z * -coefRebon;
         location.z = ((monPlato.size)/2-rayonSphere);
       } 
       else if(location.z < -((monPlato.size)/2-rayonSphere)){
         velocity.z = velocity.z * -coefRebon;
         location.z = -((monPlato.size)/2-rayonSphere);
       }
  }
  
}
