class Cylindre {
  
  PVector position; // vecteur coordoonees du cylindre
  float rayonCyl = 25; // rayon du cylindre
  float hauteurCyl = 50 ; // hauteur du cylindre
  int resolutionCyl = 40 ; // resolution du cylindre
  
  PShape openCylinder = new PShape();  // corps du cylindre
  PShape cylinBottom = new PShape();  // bas du cylindre
  PShape cylinTop = new PShape();  // haut du cylindre
  
  // initialiser cylindre
  Cylindre(float xBase, float yBase, float zBase) {
    
  float angle;
  position = new PVector(xBase, yBase, zBase);
  float[] x = new float[resolutionCyl + 1]; 
  float[] y = new float[resolutionCyl + 1];

// initialiser x et y pour tous les points du cylindre
  for(int i = 0; i < x.length; i++) {
     angle = (TWO_PI / resolutionCyl) * i; 
     x[i] = sin(angle) * resolutionCyl;
     y[i] = cos(angle) * resolutionCyl;
  }
  
  
  // partie ouverte du cylindre 
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  for(int i = 0; i < x.length; i++) { 
    openCylinder.vertex(x[i], y[i] , 0);
    openCylinder.vertex(x[i], y[i], hauteurCyl);
   }
   openCylinder.endShape();
   
   // dessous du cylindre
   cylinBottom = createShape();
   cylinBottom.beginShape(TRIANGLE_FAN);
   cylinBottom.vertex(0, 0, 0);
   for(int i = 0; i < x.length; i++) { 
    cylinBottom.vertex(x[i], y[i] , 0);
    cylinBottom.vertex(x[i], y[i], 0);
   }
   cylinBottom.endShape();

  // dessus du cylindre
   cylinTop = createShape();
   cylinTop.beginShape(TRIANGLE_FAN);
   cylinTop.vertex(0, 0, hauteurCyl);
   for(int i = 0; i < x.length; i++) { 
    cylinTop.vertex(x[i], y[i] , hauteurCyl);
    cylinTop.vertex(x[i], y[i], hauteurCyl);
   }
 
   cylinTop.endShape();
    
  }
  
  // methode pour afficher le cylindre
  void display() {
    rotateX(PI/2);
    translate(position.x, position.y, position.z);
    shape(openCylinder);
    shape(cylinBottom);
    shape(cylinTop);  
  }

  
     
  
  
 
  
  
  
  
  
  
}
