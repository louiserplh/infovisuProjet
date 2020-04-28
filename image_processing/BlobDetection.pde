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
        int[] neighbors = neighbors(input, i, labels);
      
        if(neighbors[0] == neighbors[1] && neighbors[1] == neighbors[2] && neighbors[2] == neighbors[3]) {
          if(neighbors[0] == 0) {
             labels [i] = currentLabel;
             ++currentLabel;
          }
          else {
            labels[i] = neighbors[0];
          }
        }
       
        else {
          TreeSet<Integer> tree = new TreeSet<Integer>();
          int current = 0;
          for(int j = 0; j < 4; ++j) {
            if(neighbors[j] != 0 && neighbors[j] <= current) {
              current = neighbors[j];
            }
            else {
              tree.add(neighbors[j]);
            }
          }
          tree.add(current);
          labels[i] = current;
          labelsEquivalences.add(tree);
        }
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
      int newX = x - 1 + i;
      int newY = y - 1;
      if(newX >= 0 && newX < img.width && newY >= 0 && newY < img.height) {
        res[i] = labels [newY * img.width + newX];
      }
      else {
        res[i] = 0;
      }
    }
    res[3] = (x >= 1) ? labels [currentIndex - 1] : 0;
    
    
    
    return res;
  }
}

  
