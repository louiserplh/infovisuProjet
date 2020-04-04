void settings() {
size(1000, 1000, P2D);
}

void setup () {
}

void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  //rotated around x
  float[][] transform1 = rotateXMatrix(angle); 
  float[][] transform11 = rotateYMatrix(angleY);
  float[][] transform111 = scaleMatrix(q, q, q);
  input3DBox = transformBox(transformBox(transformBox(input3DBox, transform1), transform11), transform111);
  projectBox(eye, input3DBox).render();
  
  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0);
  float[][] transform22 = scaleMatrix(p, p, p);
  input3DBox = transformBox(transformBox(input3DBox, transform2), transform22);
  projectBox(eye, input3DBox).render();
  
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(s, s, s);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();

}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float x = (p.x - eye.x) / ((eye.z - p.z)/eye.z); 
  float y = (p.y - eye.y) / ((eye.z - p.z)/eye.z);
  return new My2DPoint(x, y);
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
  this.s = s;
  }
  
  //homogenous representation on the 3D box
  void render(){
    strokeWeight(4);
    
    stroke(0, 0, 255);
    line(s[0].x, s[0].y, s[4].x, s[4].y);
    line(s[5].x, s[5].y, s[1].x, s[1].y);
    line(s[2].x, s[2].y, s[6].x, s[6].y);
    line(s[3].x, s[3].y, s[7].x, s[7].y);
    
    stroke(255, 0, 0);
    line(s[0].x, s[0].y, s[1].x, s[1].y);
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[1].x, s[1].y);
    line(s[2].x, s[2].y, s[3].x, s[3].y);
     
    stroke(0, 255, 0);
    line(s[4].x, s[4].y, s[5].x, s[5].y);
    line(s[4].x, s[4].y, s[7].x, s[7].y);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
    line(s[6].x, s[6].y, s[7].x, s[7].y);
   
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
      float x = origin.x;
      float y = origin.y;
      float z = origin.z;
      this.p = new My3DPoint[]{new My3DPoint(x,y+dimY,z+dimZ),
      new My3DPoint(x,y,z+dimZ),
      new My3DPoint(x+dimX,y,z+dimZ),
      new My3DPoint(x+dimX,y+dimY,z+dimZ),
      new My3DPoint(x,y+dimY,z),
      origin,
      new My3DPoint(x+dimX,y,z),
      new My3DPoint(x+dimX,y+dimY,z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] S = {projectPoint(eye, box.p[0]), 
                   projectPoint(eye, box.p[1]),
                   projectPoint(eye, box.p[2]), 
                   projectPoint(eye, box.p[3]),
                   projectPoint(eye, box.p[4]), 
                   projectPoint(eye, box.p[5]),
                   projectPoint(eye, box.p[6]), 
                   projectPoint(eye, box.p[7])};
  return new My2DBox(S);
}

float[] homogeneous3DPoint (My3DPoint p) {
float[] result = {p.x, p.y, p.z , 1};
return result;
}

float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), -sin(angle) , 0},
                        {0, sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
 
float[][] rotateYMatrix(float angle) {
  return(new float[][] {
                        {cos(angle), 0 , sin(angle) , 0},
                        {0, 1 , 0 , 0},
                        {-sin(angle), 0 , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}

float[][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), -sin(angle), 0 , 0},
                        {sin(angle) , cos(angle), 0 , 0},
                        {0, 0 , 1 , 0},
                        {0, 0 , 0 , 1}});
}

float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0 , 0 , 0},
                        {0, y , 0 , 0},
                        {0, 0 , z , 0},
                        {0, 0 , 0 , 1}});
}

float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0 , 0 , x},
                        {0, 1 , 0 , y},
                        {0, 0 , 1 , z},
                        {0, 0 , 0 , 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  return(new float[] {a[0][0]*b[0] + a[0][1]*b[1] + a[0][2]*b[2] + a[0][3]*b[3],
                      a[1][0]*b[0] + a[1][1]*b[1] + a[1][2]*b[2] + a[1][3]*b[3],
                      a[2][0]*b[0] + a[2][1]*b[1] + a[2][2]*b[2] + a[2][3]*b[3],
                      a[3][0]*b[0] + a[3][1]*b[1] + a[3][2]*b[2] + a[3][3]*b[3]});
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  float p0[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[0]));
  float p1[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[1]));
  float p2[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[2]));
  float p3[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[3]));
  float p4[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[4]));
  float p5[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[5]));
  float p6[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[6]));
  float p7[] =  matrixProduct(transformMatrix, homogeneous3DPoint(box.p[7]));
  
  My3DPoint[] S = {euclidian3DPoint(p0), euclidian3DPoint(p1),
                     euclidian3DPoint(p2), euclidian3DPoint(p3),
                     euclidian3DPoint(p4), euclidian3DPoint(p5),
                     euclidian3DPoint(p6), euclidian3DPoint(p7)};
 
  return new My3DBox(S) ; 
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}


float s = 2, p=1, q=0.5; 

void mouseDragged() 
{
  if (pmouseY < mouseY){
    s += 0.01 ;
    p += 0.01 ;
    q += 0.01 ;
  }
  else{
    s -= 0.01 ;
    p -= 0.01 ;
    q -= 0.01 ;
  }
}

float angle = -PI/8 ;
float angleY = 0 ; 

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle = angle + PI/50 ;
    } 
    else if (keyCode == DOWN) {
      angle = angle - PI/50;
    }
    else if (keyCode == LEFT) {
      angleY = angleY + PI/50 ;
    }
    else if (keyCode == RIGHT) {
      angleY = angleY - PI/50;
    }
  }
}
