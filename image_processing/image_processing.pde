PImage img;
PImage img2;
HScrollbar thresholdBar1;
HScrollbar thresholdBar2;

void settings() {
  size(1600, 600);
}
void setup() {
   img = loadImage("board1.jpg");
   img2 = loadImage("board1Blurred.bmp");
   
   /**
   thresholdBar1 = new HScrollbar(img.width, img.height, 600, 20);
   thresholdBar2 = new HScrollbar(img.width, img.height + 20, 600, 20);
   **/
   noLoop(); // no interactive behaviour: draw() will be called only once. 
}

void draw() {
  image(img, 0, 0);//show image
  //PImage im2 = thresholdHSB(img, 100, 200, 100, 255, 45, 100);
  PImage im2 = convolute(img);
  image(im2, img.width, 0);
  /**
  PImage im2 = hueMap(img, round(thresholdBar1.getPos()*255), round(thresholdBar2.getPos()*255));
  image(im2, img.width, 0);
  
  
  thresholdBar1.display();
  thresholdBar1.update();
  
  thresholdBar2.display();
  thresholdBar2.update();
  
  PImage im2 = threshold(img, round(thresholdBar.getPos()*255));
  image(im2, img.width, 0);
  thresholdBar.display();
  thresholdBar.update();
  **/
  
  println(imagesEqual(im2, img2));

}

boolean imagesEqual(PImage img1, PImage img2){
  if(img1.width != img2.width || img1.height != img2.height)
     return false;
   for(int i = 0; i < img1.width*img1.height ; i++)
             //assuming that all the three channels have the same value
      if(red(img1.pixels[i]) != red(img2.pixels[i])) 
      return false;
  return true; 
}

PImage hueMap(PImage img, int threshold1, int threshold2) {
  PImage result = createImage(img.width, img.height, RGB);
  //print(threshold1 + " " + threshold2 + " ");
  for(int i = 0; i < img.width * img.height; i++) {
    if(hue(img.pixels[i]) >= threshold1 && hue(img.pixels[i]) <= threshold2) {
      result.pixels[i] = img.pixels[i];
    }
  }
  result.updatePixels();
  return result;
}

PImage threshold(PImage img, int threshold){
  // create a new, initially transparent, 'result' image 
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
      if(brightness(img.pixels[i]) <= threshold) {
        result.pixels[i] = color(255, 255, 255);
      }// do something with the pixel img.pixels[i]
      else {
        result.pixels[i] = color(0, 0, 0); 
      }
  }
  result.updatePixels();
  return result;
}

PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB) {
  PImage result = createImage(img.width, img.height, RGB);
  
  for(int i = 0; i < img.width * img.height; i++) {
    
    int pixel = img.pixels[i];
    
    // Hue part
    if(hue(pixel) >= minH && hue(pixel) <= maxH) {
      if(saturation(pixel) >= minS && saturation(pixel) <= maxS) {
        if(brightness(pixel) >= minB && brightness(pixel) <= maxB) {
          result.pixels[i] = color(255, 255, 255);
        }
      }
    }
    else {
      result.pixels[i] = color(0, 0, 0);
    }
    
    
  }
    
  result.updatePixels();
  return result;
}

PImage convolute(PImage img) {
  float[][] kernel = { { 9, 12, 9 },
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
      float sum=sqrt(pow(sum_h, 2) + pow(sum_v, 2));
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
