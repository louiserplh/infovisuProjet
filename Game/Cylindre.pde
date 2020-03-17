class Cylindre {
  
  PVector position; // vecteur coordoonees du cylindre
  float rayonCyl = 25; // rayon du cylindre
  float hauteurCyl = 50 ; // hauteur du cylindre
  int resolutionCyl = 40 ; // resolution du cylindre
  
  PShape openCylinder = new PShape();  // corps du cylindre
  PShape cylinBottom = new PShape();  // bas du cylindre
  PShape cylinTop = new PShape();  // haut du cylindre
  
   
  Cylindre(float xBase, float yBase) {
    
  float angle;
  position = new PVector(xBase, yBase);
  float[] x = new float[resolutionCyl + 1]; 
  float[] y = new float[resolutionCyl + 1];
  //get the x and y position on a circle for all the sides

  for(int i = 0; i < x.length; i++) {
     angle = (TWO_PI / resolutionCyl) * i; 
     x[i] = sin(angle) * resolutionCyl;
     y[i] = cos(angle) * resolutionCyl;
  }
  
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for(int i = 0; i < x.length; i++) { 
    openCylinder.vertex(x[i], y[i] , 0);
    openCylinder.vertex(x[i], y[i], hauteurCyl);
   }
   openCylinder.endShape();
   
   cylinBottom = createShape();
   cylinBottom.beginShape(TRIANGLE_FAN);
   cylinBottom.vertex(0, 0, 0);
   for(int i = 0; i < x.length; i++) { 
    cylinBottom.vertex(x[i], y[i] , 0);
    cylinBottom.vertex(x[i], y[i], 0);
   }
 
   cylinBottom.endShape();

   cylinTop = createShape();
   cylinTop.beginShape(TRIANGLE_FAN);
   cylinTop.vertex(0, 0, hauteurCyl);
   for(int i = 0; i < x.length; i++) { 
    cylinTop.vertex(x[i], y[i] , hauteurCyl);
    cylinTop.vertex(x[i], y[i], hauteurCyl);
   }
 
   cylinTop.endShape();
    
  }
  
  void display() {
    rotateX(PI/2);
    translate(position.x, position.y);
    shape(openCylinder);
    shape(cylinBottom);
    shape(cylinTop);  
  }

  
     
  
  
 
  
  
  
  
  
  
}
