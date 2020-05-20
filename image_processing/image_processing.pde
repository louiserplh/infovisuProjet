PImage img;
PImage img2;
PImage houghImg;
BlobDetection blob = new BlobDetection();
QuadGraph quad = new QuadGraph();

void settings() {
  size(800, 645);
}
void setup() {
   img = loadImage("board1.jpg");
   noLoop(); // no interactive behaviour: draw() will be called only once. 

   houghImg = loadImage("hough_test.bmp");
}

void draw() {
  
  
  
  //PImage im2 = hueMap(img, 115, 134);
  PImage im2 = thresholdHSB(img,115, 134, 0,255,0,255);
  //im2 = convolute(im2);
  im2 = blob.findConnectedComponents(im2, true);
  im2 = scharr(im2);
  im2 = thresholdBrightness(img, im2, 84, 100);
 

  //image(im2, 0, 0);//show image
  List<PVector> lignes = hough(im2,10,10);
  
  image(im2, 0, 0);
  List<PVector> quads = quad.findBestQuad(lignes,im2.width,im2.height,(im2.width*im2.height),(im2.width*im2.height)/6, false);
  println(quads);
  plot(im2, lignes,quads);
}

PImage hueMap(PImage img, int threshold1, int threshold2) {
  PImage result = createImage(img.width, img.height, RGB);
  
  for(int i = 0; i < img.width * img.height; i++) {
    if(hue(img.pixels[i]) >= threshold1 && hue(img.pixels[i]) <= threshold2) {
      result.pixels[i] = color(255, 255, 255);
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
      }
      else {
        result.pixels[i] = color(0, 0, 0); 
      }
  }
  result.updatePixels();
  return result;
}

PImage thresholdHSB(PImage img2, int minH, int maxH, int minS, int maxS, int minB, int maxB) {
  PImage result = createImage(img2.width, img2.height, RGB);
  
  for(int i = 0; i < img2.width * img2.height; i++) {
    
    int pixel = img2.pixels[i];
    
    // Hue part
    if(hue(pixel) >= minH && hue(pixel) <= maxH) {
      if(saturation(pixel) >= minS && saturation(pixel) <= maxS) {
        if(brightness(pixel) >= minB && brightness(pixel) <= maxB) {
          result.pixels[i] = color(255,255,255);
        }
      }
    }

    
    
  }
    
  result.updatePixels();
  return result;
}

PImage thresholdBrightness(PImage img, PImage img2, int minB, int maxB) {
  
  //PImage result = createImage(img.width, img.height, RGB);
  
  for(int i = 0; i < img.width * img.height; i++) {
    
    int pixel = img2.pixels[i];
    
    if(!(brightness(pixel) >= minB && brightness(pixel) <= maxB)) {
          img2.pixels[i] = color(0, 0, 0);
     }
  }
    
  img2.updatePixels();
  return img2;
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
    stroke(100,0,0);
    noFill();
    circle(quads.get(i).x, quads.get(i).y,30);
  }

}
