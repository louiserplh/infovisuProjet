
class Ball {
  
  PVector gravityForce ;
  PVector location ;
  PVector velocity ;
  float gravityConst = 1 ;
  float coefRebon = 0.5 ;
  
  
  
  Ball(){
    gravityForce = new PVector(0, 0, 0);
    location = new PVector(0, -15, 0);
    velocity = new PVector(0, 0, 0);
  }
  
  
  void update(){
    gravityForce.set(rZ*gravityConst, 0, -rX*gravityConst);
    velocity.add(gravityForce);
    location.add(velocity);
  }
  
  void display(){
     pushMatrix(); 
     noStroke(); 
     fill(255); 
     translate(location.x, location.y, location.z);
     sphere(10); 
     popMatrix();
  }
  
  void checkEdges(){
    if(location.x > 100) {
         velocity.x = velocity.x * -coefRebon;
         location.x = 100;
       } else if(location.x < -100){
         velocity.x = velocity.x * -coefRebon;
         location.x = -100;
       }
       if(location.z > 100) {
         velocity.z = velocity.z * -coefRebon;
         location.z = 100;
       } else if(location.z < -100){
         velocity.z = velocity.z * -coefRebon;
         location.z = -100;
       }
  }
}
