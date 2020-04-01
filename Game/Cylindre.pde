  /*
  *  Cylindre.pde  
  *  Classe pour gerer les cylindres dans le jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */
  

class Cylindre {
  
  PVector position; // vecteur coordoonees du cylindre
  float rayonCyl = 20 ; // rayon du cylindre
  float hauteurCyl = 50 ; // hauteur du cylindre
  int resolutionCyl = 20 ; // resolution du cylindre
  
  float angle; // angle pour la construction du cylindre
  float[] x = new float[resolutionCyl + 1]; // variable pour la construction du cylindre
  float[] z = new float[resolutionCyl + 1]; // variable pour la construction du cylindre
  
  PShape openCylinder = new PShape();  // corps du cylindre
  PShape cylinBottom = new PShape();  // bas du cylindre
  PShape cylinTop = new PShape();  // haut du cylindre
  PShape cylinEntier = new PShape(); // cylindre complet
  
 
  // constructeur du cylindre
  Cylindre(float xBase, float yBase, float zBase) {
    stroke(255, 200, 0) ; 
    fill(255, 0, 0) ;
    lights() ; 
    position = new PVector(xBase, yBase, zBase);
 
  // initialiser x et y pour tous les points du cylindre
  for(int i = 0; i < x.length; i++) {
     angle = (TWO_PI / resolutionCyl) * i; 
     x[i] = sin(angle) * rayonCyl;
     z[i] = cos(angle) * rayonCyl;
  }
  
  // partie ouverte du cylindre 
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  for(int i = 0; i < x.length; i++) { 
    openCylinder.vertex(x[i], 0 , z[i]);
    openCylinder.vertex(x[i], hauteurCyl, z[i]);
   }
   openCylinder.endShape();
   
   // dessous du cylindre
   cylinBottom = createShape();
   cylinBottom.beginShape(TRIANGLE_FAN);
   cylinBottom.vertex(0, 0, 0);
   for(int i = 0; i < x.length; i++) { 
    cylinBottom.vertex(x[i], 0, z[i]);
   }
   cylinBottom.endShape();

  // dessus du cylindre
   cylinTop = createShape();
   cylinTop.beginShape(TRIANGLE_FAN);
   cylinTop.vertex(0, hauteurCyl, 0);
   for(int i = 0; i < x.length; i++) { 
    cylinTop.vertex(x[i], hauteurCyl, z[i]);
   }
   cylinTop.endShape();
   
  // Assemblage du cylindre avec les diverses parties 
   cylinEntier = createShape(GROUP) ; 
   cylinEntier.addChild(cylinBottom);
   cylinEntier.addChild(openCylinder);
   cylinEntier.addChild(cylinTop);
  }
  
  // methode pour afficher le cylindre
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    shape(cylinEntier);
    popMatrix();
  }

  // methode pour s'assurer que le cylindre se situe sur le plateau
  boolean surLePlateau(Plateau plateau){
    return ((abs(position.x) <= plateau.size / 2 ) &&
             abs(position.z) <= plateau.size / 2 ) ; 
   }
   
   // methode pour s'assurer que deux cylindres ne se superposent pas
   boolean chevauchement(ArrayList<Cylindre> mesCylindres, Ball ball){
       PVector vectDistanceBall = new PVector (position.x - ball.location.x, 0, position.z - ball.location.z);
       float distanceBalle = vectDistanceBall.mag(); 
       if(distanceBalle <= (rayonCyl + ball.diametreSphere)){
         return true ; 
       }
       for (int i = 0 ; i < mesCylindres.size(); ++i) {
         PVector vectDistanceCyl = new PVector (position.x - mesCylindres.get(i).position.x, 0, position.z - mesCylindres.get(i).position.z);
         float distanceCylindre = vectDistanceCyl.mag(); 
         if(distanceCylindre <= 2 * rayonCyl){
          return true ;  
         }
       }
       return false ; 
   }
  
}
