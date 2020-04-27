import java.util.ArrayList; 
import java.util.List; 
import java.util.TreeSet;

class BlobDetection {
  
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    // First pass: label the pixels and store labels' equivalences
    
    int [] labels = new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
    
    int currentLabel = 1; 
    
    for(int i = 0; i < input.width*input.height; ++i) {
      if(brightness(img.pixels[i]) == 255 && saturation(img.pixels[i]) == 255) { // if hsb white encoding
        
      }
      else {
        labels [i] = 0;
      }
      
    }
    // TODO!
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
    int x = currentIndex % img.width;
    int y = currentIndex/img.width;
    
    for(int i = 0; i <= 2; ++i) {
      res[i] = labels [(y - 1) * img.width + (x - 1 + i)];
    }
    res[3] = labels [currentIndex - 1];
    
    
    
    return res;
  }
}

  
