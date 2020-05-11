
List<PVector> hough(PImage edgeImg) {
  
  float discretizationStepsPhi = 0.06f; 
  float discretizationStepsR = 2.5f; 
  int minVotes=30;
  
  //dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi +1);
  
  //The max radius is the image diagonal, but it can be also negative 
  int rDim = (int) ((sqrt(edgeImg.width*edgeImg.width + 
                    edgeImg.height*edgeImg.height) * 2) / discretizationStepsR +1); 
                    
  // our accumulator
  int[] accumulator = new int[phiDim * rDim];
  
  // Fill the accumulator: on edge points (ie, white pixels of the edge 
  // image), store all possible (r, phi) pairs describing lines going 
  // through the point.
  
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      
    // Are we on an edge?
    
    if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
            // ...determine here all the lines (r, phi) passing through
            // pixel (x,y), convert (r,phi) to coordinates in the
            // accumulator, and increment accordingly the accumulator.
            // Be careful: r may be negative, so you may want to center onto
            // the accumulator: r += rDim / 2
            
          for(float phi = 0; phi< Math.PI; phi += discretizationStepsPhi){
            float r = (float)((x*Math.cos(phi))+(y*Math.sin(phi)));
            if(r < 0) { r+= (float) rDim/2; }
            int position = (int)(phi * rDim + r);
            
            accumulator[position] += 1;
        }
      } 
    }
  }

  ArrayList<PVector> lines = new ArrayList<PVector>(); 

  for (int idx = 0; idx < accumulator.length; idx++) { 
    if (accumulator[idx] > minVotes) {
      
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim));
      int accR = idx - (accPhi) * (rDim);
      float r = (accR - (rDim) * 0.5f) * discretizationStepsR; 
      float phi = accPhi * discretizationStepsPhi; 
      
      lines.add(new PVector(r,phi));
    }
  }
  
    //display the accumulator
  PImage houghImg = createImage(rDim, phiDim, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }  
  // You may want to resize the accumulator to make it easier to see:
  houghImg.resize(1000, 1000);
  //test
  houghImg.updatePixels();
  image(houghImg,0,0);
  
  
  return lines;
}
