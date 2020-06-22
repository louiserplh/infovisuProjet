import processing.video.*; 
class ImageProcessing extends PApplet {
  

Capture cam;
PImage img;
  
void settings() {
  size(640, 480);
}

// initialisation de l'image
void setup() {
   
   String[] cameras = Capture.list(); 
cam = new Capture(this, cameras[0]);
        //If you're using gstreamer1.0 (Ubuntu 16.10 and later),
        //select your resolution manually instead:
        //cam = new Capture(this, 640, 480, cameras[0]);
        cam.start();
}

// dessin des différentes images avec différentes méthodes de processing
void draw() {
  
  if (cam.available() == true) {
        cam.read();
    }
    img = cam.get();
    PImage im2 = thresholdHSB(img, 230, 255, 0, 255, 200, 255);  
  im2 = convolute(im2);
  im2 = blob.findConnectedComponents(im2, true);
  im2 = scharr(im2);
  im2 = thresholdBrightness(img, im2, 0, 100);
  List<PVector> lignes = hough(im2,10,10);
  image(img, 0, 0);
  List<PVector> quads = quad.findBestQuad(lignes,im2.width,im2.height,(im2.width*im2.height),(im2.width*im2.height)/6, false);
  plot(im2, lignes, quads);//lines + coins
  
  
  
}
}
