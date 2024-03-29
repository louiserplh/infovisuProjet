  /*
  *  Game.pde  
  *  Classe principale du jeu
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */
 
  
  PShape evil;
  
  Ball maBoule;
  Plateau monPlato; 
  ParticleSystem cylindres;
  PGraphiques affichage ; 
  
  float timeStart ; 
  float timeElapsed ; 
  float rapidity = 0.02;
  
  int topViewSize = 300 ;
  int frameSize = 20 ; 
  int lastScore = 0 ; 
  int totalScore = 0 ; 
  int scrollBarHeight = 30 ;
  
  boolean timeReset = true ;
  boolean wasInitialised = false;
  boolean ajoutCylindre ; 
  boolean removeCylindre ;
  boolean partieFinie ; 
  
  PImage img;
  BlobDetection blob = new BlobDetection();
  QuadGraph quad = new QuadGraph();
  import processing.video.*; 
  import gab.opencv.*;
  OpenCV opencv;
  Capture cam;
  TwoDThreeD conv;
  //PImage img;
  
  float rotationX;
  float rotationY;
  // taille de la fenetre
  void settings() {
    fullScreen();      
       //size(600*3 + 2, 450);
      opencv = new OpenCV(this,100,100);
      size(640, 480);
  }
  
  // initialisation des elements de jeu
  void setup() {     
    affichage = new PGraphiques();
    monPlato = new Plateau();
    maBoule = new Ball(monPlato);
    PImage img = loadImage("robotnik.png");
    evil = loadShape("robotnik.obj");
    evil.setTexture(img);
    
    img = loadImage("board1.jpg");
     //noLoop(); // no interactive behaviour: draw() will be called only once. 
     /*String[] cameras = Capture.list(); 
     //If you're using gstreamer0.1 (Ubuntu 16.04 and earlier),
     //select your predefined resolution from the list:
     // cam = new Capture(this, cameras[21]);
    //If you're using gstreamer1.0 (Ubuntu 16.10 and later),
    //select your resolution manually instead:
    cam = new Capture(this, 640, 480, cameras[0]);
    cam.start();*/
    conv = new TwoDThreeD(img.width, img.height, 0);
  }
   
  void draw() {
    PImage im2 = thresholdHSB(img, 75, 140, 50, 255, 30, 255);
    im2 = convolute(im2);
    im2 = blob.findConnectedComponents(im2, true);
    PImage right = im2.copy();
    im2 = scharr(im2);
    im2 = thresholdBrightness(img, im2, 10, 180);
    PImage middle = im2.copy();
    
    List<PVector> lignes = hough(im2,10,10);
    image(img, 0, 0);
    List<PVector> quads = quad.findBestQuad(lignes,im2.width,im2.height,(im2.width*im2.height),(im2.width*im2.height)/15, false);
    plot(im2, lignes, quads);//lines + coins
    //image(right, img.width*2 + 2, 0); //only blob
    //image(middle, img.width + 1, 0); //edges
    
    /*if (cam.available() == true) {
    cam.read();
    }
    img = cam.get();
    image(img, 0, 0);*/
    homogeneous(quads);
    PVector vect = conv.get3DRotations(quads);
    println(quads.size());
    println("rX = " + getAngle(vect.x) + 
          " rY = " + getAngle(vect.y) + 
          " rZ = " + getAngle(vect.z));
    
    affichage.drawGame();
    image(affichage.gameSurface, 0, 0);
    affichage.myBackground();
    image(affichage.myBackground,0,height-topViewSize);
    affichage.topView();
    image(affichage.topView, frameSize/2 ,height-topViewSize + frameSize/2);
    affichage.scoreBoard();
    image(affichage.scoreBoard, topViewSize + frameSize/2, height-topViewSize + frameSize/2); 
    affichage.barChart();
    image(affichage.barChart, 2*topViewSize + frameSize/2 , height-topViewSize + frameSize/2); 
    affichage.scrollBar();
    image(affichage.scrollBar, 2*topViewSize + frameSize/2, height - scrollBarHeight - frameSize / 2);
    affichage.victory(); 
    image(affichage.victory, 0, 0); 
    
    //edges
    monPlato.rotationX = getAngle(vect.x);
    monPlato.rotationZ = getAngle(vect.y);
  }
  
  
    // detecte si on appuye sur la touche Shift
    boolean appuierSurShift(){
      return (keyPressed == true && keyCode == SHIFT); 
    }
    
    //detecte si on appuye sur la touche Enter
    boolean appuierSurCtrl(){
      return (keyPressed == true && keyCode == CONTROL);
    }
  
    // rotation du plateau en fonction des axes
    void mouseDragged() { 
      if(pmouseX < mouseX && monPlato.rotationZ < (PI/3) && mouseY < height-topViewSize) {
        monPlato.rotationZ = monPlato.rotationZ + rapidity; 
      }
      else if(pmouseX > mouseX && monPlato.rotationZ > (-PI/3) && mouseY < height-topViewSize) {
        monPlato.rotationZ = monPlato.rotationZ - rapidity; 
      }
      if(pmouseY < mouseY && monPlato.rotationX > (-PI/3) && mouseY < height-topViewSize) {
        monPlato.rotationX = monPlato.rotationX - rapidity; 
      }
      else if(pmouseY > mouseY && monPlato.rotationX < (PI/3) && mouseY < height-topViewSize ) {
        monPlato.rotationX = monPlato.rotationX + rapidity; }
    }
    
    // gérer la rapidité de la rotation
    void mouseWheel(MouseEvent event) { 
      
      if (event.getCount() > 0 && rapidity < 0.2) {
        rapidity += 0.01;
      }
      if (event.getCount() < 0 && rapidity > 0.01) {
        rapidity -= 0.01;
      }
    }
                           
    // rajouter le cylindre initial
    void mouseClicked() {
      if(appuierSurShift()) {
        
        PVector origin = new PVector(mouseX - displayWidth / 2,
                                     -50 - monPlato.thicc/2,
                                     mouseY - displayHeight / 2);
        if(monPlato.surLePlateau(origin)) {        
          cylindres = new ParticleSystem(origin, monPlato, maBoule, evil, affichage.accentColor);
          wasInitialised = true;
        }
      }
    }  

    
// méthode pour afficher la hueMap de l'image
PImage hueMap(PImage img) {
  
  // création d'une image initialement transparente
  PImage result = createImage(img.width, img.height, RGB);
  
  // pour chaque pixel dans img, colorer le pixel correspondant dans result en fonction de la hue
  for(int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(hue(img.pixels[i]));
  }
  result.updatePixels();
  return result;
}

// méthode pour garder seulement les pixels dont l'intensité est inférieure à threshold
PImage threshold(PImage img, int threshold){
 
  // création d'une image initialement transparente
  PImage result = createImage(img.width, img.height, RGB); 
  
  for(int i = 0; i < img.width * img.height; i++) {
      if(brightness(img.pixels[i]) <= threshold) {
        result.pixels[i] = color(255, 255, 255); // couleur blanche pour pixels dont l'intensité <= threshold
      }
      else {
        result.pixels[i] = color(0, 0, 0);  // sinon couleur noire
      }
  }
  result.updatePixels();
  return result;
}

// méthode pour garder les pixels par rapport aux thresholds HSB donnés
PImage thresholdHSB(PImage img2, int minH, int maxH, int minS, int maxS, int minB, int maxB) {
  
  // création d'une image initialement transparente
  PImage result = createImage(img2.width, img2.height, RGB);
  
  for(int i = 0; i < img2.width * img2.height; i++) {
    
    int pixel = img2.pixels[i];
    
    if(hue(pixel) >= minH && hue(pixel) <= maxH) { // partie hue
      if(saturation(pixel) >= minS && saturation(pixel) <= maxS) { // partie saturation
        if(brightness(pixel) >= minB && brightness(pixel) <= maxB) { // partie intensité
          result.pixels[i] = color(255,255,255); // couleur blanche pour les pixels en question
        }
      }
    }
  }
    
  result.updatePixels();
  return result;
}

// méthode pour garder dans img2 seulement les pixels dont l'intensité dans img est dans le threshold donné
PImage thresholdBrightness(PImage img, PImage img2, int minB, int maxB) {
  
  
  for(int i = 0; i < img.width * img.height; i++) {
    
    int pixel = img.pixels[i]; // pixel choisi par rapport à img
    
    if(!(brightness(pixel) >= minB && brightness(pixel) <= maxB)) {
          img2.pixels[i] = color(0, 0, 0); // pixel mis à noir dans img2 s'il n'est pas dans le threshold
     }
  }
    
  img2.updatePixels();
  return img2;
}

PImage convolute(PImage img) {
  float[][] kernel = { { 9, 12, 9 }, //gaussianKernel
                     { 12, 15, 12 },
                     { 9, 12, 9 }};
  float normFactor = 99.f;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  int N = 3; //kernel size
  //
  // for each (x,y) pixel in the image:
  // - multiply intensities for pixels in the range
  // (x - N/2, y - N/2) to (x + N/2, y + N/2) by the
  // corresponding weights in the kernel matrix
  // - sum all these intensities and divide it by normFactor
  // - set result.pixels[y * img.width + x] to this value
  for(int y=1; y<img.height-1; ++y){
    for(int x=1; x<img.width-1; ++x){
      float sum =0;
      for(int j = y-N/2, n=0; j<=y+N/2 && n<N;++j,++n){ 
        for(int i = x-N/2, m=0; i<=x+N/2 && m<N; ++i,++m){
          sum += brightness(img.pixels[j * img.width + i])* kernel[n][m];
        }
      }
      result.pixels[y * img.width + x] =color(sum/normFactor);
    }
  }
  return result;
}

//Edge Detection
PImage scharr(PImage img) {
  float[][] vKernel = {
    { 3, 0, -3 },
    { 10, 0, -10 },
    { 3, 0, -3 } };
  float[][] hKernel = {
    { 3, 10, 3 },
    { 0, 0, 0 },
    { -3, -10, -3 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  int N = 3; //kernel size
// *************************************
  // same as the convolute fonction
  for(int y=1; y<img.height-1; ++y){
    for(int x=1; x<img.width-1; ++x){
      float sum_h = 0;
      float sum_v = 0;
      //apply calculation with the kernel
      for(int j = y-N/2, n=0; j<=y+N/2 && n<N;++j,++n){ 
        for(int i = x-N/2, m=0; i<=x+N/2 && m<N; ++i,++m){
          sum_h += brightness(img.pixels[j * img.width + i])* hKernel[n][m];
          sum_v += brightness(img.pixels[j * img.width + i])* vKernel[n][m];
        }
      }
      //compute the compound sum as an Euclidian distance
      float sum=sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      //store in the buffer
      buffer[y*img.width + x]=sum;
      if(sum>max){
        max = sum;
      }
    }
  }
// *************************************
  for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width - 1; x++) { // Skip left and right
      int val=(int) ((buffer[y * img.width + x] / max)*255);
      result.pixels[y * img.width + x]=color(val);
    }
  }
  return result;
}

void plot(PImage edgeImg, List<PVector> lines, List<PVector> quads){
  
  for (int idx = 0; idx < lines.size(); idx++) {
    PVector line=lines.get(idx);
    float r = line.x;
    float phi = line.y;
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    // Finally, plot the lines
    stroke(204,102,0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    }
    else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
         else
          line(x1, y1, x3, y3);
      }
      else
        line(x2, y2, x3, y3);
    }
  }
  for(int i = 0; i<quads.size(); i++){
    stroke(0,0,0);
    fill(#f7347a, 60);
    circle(quads.get(i).x, quads.get(i).y,30);
  }

}

void homogeneous(List<PVector> quads){
  for(int i = 0; i<quads.size(); ++i){
    quads.get(i).set(quads.get(i).x,quads.get(i).y, 1);
  }
}

float getAngle(float angle){
  angle = (angle*180)/PI;
  if(angle>60){
    angle -= 180;
  }
  else if(angle<-60){
    angle += 180;
  }
  return angle;
}
    
