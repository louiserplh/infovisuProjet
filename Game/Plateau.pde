  /*
  *  Plateau.pde  
  *  Classe pour gerer le plateau principal du jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */


class Plateau {

  float rotationX ; // rotation de l'angle X
  float rotationZ ; // rotation de l'angle Z
  final float size = 400 ; // taille d'un cote du plateau [car c'est un carree] 
  final float thicc = 20 ; // epaisseur du plateau

  // constructeur du plateau
  Plateau(){
    rotationX = 0 ;
    rotationZ = 0 ;
  }
  
  // methode pour afficher le plateau
  void display(boolean appuierSurShift,PGraphics pg){
    pg.stroke(0);
    pg.fill(200);
    pg.lights(); 
     
    pg.translate(width/2, height/2, 0);
     
    if (appuierSurShift){
      pg.rotateX(-PI/2.0);
    }
    else {
      pg.rotateX(rotationX);
      pg.rotateZ(rotationZ);
    }
    pg.box(size, thicc, size); 
  }
  
   boolean surLePlateau(PVector origin){
    return ((abs(origin.x) <= this.size / 2 ) &&
             abs(origin.z) <= this.size / 2 ) ; 
   }
}
