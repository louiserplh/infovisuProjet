class Cylindre {
  
  PVector position; // vecteur coordoonees du cylindre
  float rayonCyl = 20 ; // rayon du cylindre
  float hauteurCyl = 50 ; // hauteur du cylindre
  int resolutionCyl = 30 ; // resolution du cylindre
  
  PShape openCylinder = new PShape();  // corps du cylindre
  PShape cylinBottom = new PShape();  // bas du cylindre
  PShape cylinTop = new PShape();  // haut du cylindre
  
  // initialiser cylindre
  Cylindre(float xBase, float yBase, float zBase) {
    
  float angle;
  position = new PVector(xBase, yBase, zBase);
  float[] x = new float[resolutionCyl + 1]; 
  float[] z = new float[resolutionCyl + 1];

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
    cylinBottom.vertex(x[i], 0, z[i]);
   }
   cylinBottom.endShape();

  // dessus du cylindre
   cylinTop = createShape();
   cylinTop.beginShape(TRIANGLE_FAN);
   cylinTop.vertex(0, hauteurCyl, 0);
   for(int i = 0; i < x.length; i++) { 
    cylinTop.vertex(x[i], hauteurCyl, z[i]);
    cylinTop.vertex(x[i], hauteurCyl, z[i]);
   }
 
   cylinTop.endShape();
    
  }
  
  // methode pour afficher le cylindre
  void display() {
    stroke(0, 0, 255); 
    fill(240);
    translate(position.x, position.y, position.z);
    shape(openCylinder);
    shape(cylinBottom);
    shape(cylinTop);  
  }

  
     
  
  
 
  
  
  
  
  
  
}
