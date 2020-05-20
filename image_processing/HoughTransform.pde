import java.util.Collections;
List<PVector> hough(PImage edgeImg, Integer nLines, Integer neighbours) {
  
  float discretizationStepsPhi = 0.06f; 
  float discretizationStepsR = 2.5f; 
  int minVotes=250;
  
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
            
            
           
        
        for(int phiIndex = 0; phiIndex < phiDim; phiIndex++) {
          float phi = phiIndex * discretizationStepsPhi;
          float r = (float)((x*Math.cos(phi))+(y*Math.sin(phi)));
          int rIndex = (int) ((r / discretizationStepsR) + rDim/2);
          int position = (phiIndex * rDim + rIndex);
          accumulator[position] += 1;
          
        }
      } 
    }
  }

  ArrayList<PVector> lines = new ArrayList<PVector>(); 
  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();

  for (int idx = 0; idx < accumulator.length; idx++) { 
    if (accumulator[idx] > minVotes) {
      if(neighbours(idx,accumulator,neighbours)){
      bestCandidates.add(idx);
      }
    }
  }
  Collections.sort(bestCandidates, new HoughComparator(accumulator));
  for(int i=0; i<min(nLines,bestCandidates.size()); i++){
    int accPhi = (int) (bestCandidates.get(i) / (rDim));
    int accR =  bestCandidates.get(i)- (accPhi) * (rDim);
    float r = (accR - (rDim) * 0.5f) * discretizationStepsR; 
    float phi = accPhi * discretizationStepsPhi; 
      
    lines.add(new PVector(r,phi));
  }
  
    //display the accumulator
 // PImage houghImg = createImage(rDim, phiDim, ALPHA);
    //for (int i = 0; i < accumulator.length; i++) {
      //houghImg.pixels[i] = color(min(255, accumulator[i]));
   // }  
  // You may want to resize the accumulator to make it easier to see:
  //houghImg.resize(400, 400);
  //test
  //houghImg.updatePixels();
  //image(houghImg,0,0);
  
  
  return lines;
}
boolean neighbours(int index, int[] accumulator, int neighbours){
  for(int i = index-neighbours; i<= index+neighbours; ++i){
    if(accumulator[i]>accumulator[index]){
      return false;
    }
  }
  return true;
}
