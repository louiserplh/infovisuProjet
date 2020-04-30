import java.util.ArrayList; 
import java.util.List; 
import java.util.TreeSet;

class BlobDetection {
  
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    
    // First pass: label the pixels and store labels' equivalences
    
    int [] labels = new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
    int currentLabel = 1; 
    
    colorMode(HSB, 100, 100, 100);
    
    // TODO!
    
    for(int i = 0; i < input.width*74; ++i) { // iterate over all pixels
    
      if(brightness(input.pixels[i]) == 100) { // if pixel is white
        int[] neighbors = neighbors(input, i, labels);
        //println(i + " : " + neighbors[0] + " " + neighbors[1] + " " + neighbors[2] + " " + neighbors[3] + " ");
        
        if(sameLabels(neighbors)) {
          
          int firstInFrame = firstInFrame(neighbors);
          
          if(firstInFrame == 0 || firstInFrame == -1) { // if no labels yet
            labels [i] = currentLabel;
            ++currentLabel; }
            
           else { // if all have same index
             labels [i] = firstInFrame; }  
        }
     
        
      }
      else {
        labels [i] = 0; // otherwise label is 0 (no label)
      }
      
      println(i + " : " + labels [i]);
      
    }
    
    
    
  
    // Second pass: re-label the pixels by their equivalent class
    // if onlyBiggest==true, count the number of pixels for each label
    
    // TODO!
            
    // Finally:  
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob in white and others in black

    // TODO!
    
    return input;
  } 


  int [] neighbors(PImage img, int currentIndex, int [] labels) {
      int [] res = new int[4];
      for(int i = 0; i < 4; ++i) { res [i] = -1; } // initialize all array vals to -1 (outside of frame)
      
      int x = currentIndex % img.width;
      int y = currentIndex/img.width;
      
      if(y - 1 >= 0) {
        if(x - 1 >= 0) { 
          res[0] = labels[(y - 1)*img.width + x - 1]; 
        }
        res[1] = labels[(y - 1)*img.width + x];
        if(x + 1 < img.width) { res[2] = labels[(y - 1)*img.width + x + 1]; }
      }
      if (x - 1 >= 0) { res[3] = labels[currentIndex - 1]; }
      
      return res;
  }
  
  // returns whether all in-frame labels are the same
  boolean sameLabels(int [] neighbors) {
    int current = -2;
    
    for(int i = 0; i < neighbors.length ; ++i) {
      
      if(neighbors[i] != -1 && neighbors[i] != 0 && neighbors[i] != current) {
        if(current != -2) { return false; }
        else { current = neighbors[i]; }
      }
  
    }
    return true;
  }
  
  
  // returns the label of the first label in frame or -1 if there is none
  int firstInFrame(int [] neighbors) { 
    
    for(int i = 0; i < neighbors.length; ++i) {
      if(neighbors[i] != -1 && neighbors[i] != 0) {
        return neighbors[i];
      }
    }
    
    return -1;
  }
  
}
