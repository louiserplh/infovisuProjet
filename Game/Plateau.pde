class Plateau {

  float rotationX ; // rotation de l'angle X
  float rotationZ ; // rotation de l'angle Z
  final float size = 350 ; // taille d'un cote du plateau [car c'est un carree] 
  final float thicc = 20 ; // epaisseur du plateau

  // constructeur du plateau
  Plateau(){
    rotationX = 0 ;
    rotationZ = 0 ;
  }
  
  // methode pour afficher le plateau
  void display(boolean appuierSurShift, ArrayList<Cylindre> mesCylindres){
     stroke(0);
     fill(200);
     lights(); 
     translate(width/2, height/2, 0);
     
     if (appuierSurShift){
       rotateX(-PI/2.0);
     }
     else {
       rotateX(rotationX);
       rotateZ(rotationZ);
     }
     box(size, thicc, size); 
     
     // dessiner cylindres
     for(int i = 0; i < mesCylindres.size(); ++i) {
       pushMatrix();
       mesCylindres.get(i).display();
       popMatrix();
     }
  }
  

}
