class Plateau {

  float rotationX ; // rotation de l'angle X
  float rotationZ ; // rotation de l'angle Z
  final float size = 200 ; // taille d'un cote de la boite, car c'est un carree 
  final float thicc = 10 ; // epaisseur de la b
  
  
  Plateau(){
    rotationX = 0 ;
    rotationZ = 0 ;
  }
  
  void display(){
     noStroke();
     fill(150);
     lights(); 
     translate(width/2, height/2, 0);
     rotateX(rotationX);
     rotateZ(rotationZ);
     box(size, thicc, size);     
  }

}
