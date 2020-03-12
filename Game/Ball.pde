
class Ball {
  
  PVector gravityForce ;
  PVector location ;
  PVector velocity ;
  float gravityConst = 0.8 ;
  float coefRebon = 0.5 ;
  int diametreSphere = 10 ;
  int rayonSphere = diametreSphere/2 ;
  
  // Il faudrait faire une classe plateau je pense, comme ca si on doit changer la taille du plateau et tout ca. 
 
  
  Ball(){
    gravityForce = new PVector(0, 0, 0);
    location = new PVector(0, -(10+rayonSphere), 0);
    velocity = new PVector(0, 0, 0);
  }
  
  
  void update(){
    gravityForce.set(sin(rZ)*gravityConst, 0, -sin(rX)*gravityConst);
    velocity.add(gravityForce);
    location.add(velocity);
  }
  
  void display(){
     pushMatrix(); 
     noStroke(); 
     fill(100); 
     translate(location.x, location.y, location.z);
     sphere(diametreSphere); 
     popMatrix();
  }
  
  void checkEdges(){
    if(location.x > 100-rayonSphere) {
         velocity.x = velocity.x * -coefRebon;
         location.x = (100-rayonSphere);
       } else if(location.x < -(100-rayonSphere)){
         velocity.x = velocity.x * -coefRebon;
         location.x = -(100-rayonSphere);
       }
       if(location.z > (100-rayonSphere)) {
         velocity.z = velocity.z * -coefRebon;
         location.z = (100-rayonSphere);
       } else if(location.z < -(100-rayonSphere)){
         velocity.z = velocity.z * -coefRebon;
         location.z = -(100-rayonSphere);
       }
  }
}
