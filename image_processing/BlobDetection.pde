import java.util.ArrayList;
import java.util.SortedMap;
import java.util.List; 
import java.util.TreeSet;
import java.util.Map;
import java.util.TreeMap; 

class BlobDetection {
  
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    
    // First pass: label the pixels and store labels' equivalences
    
    int [] labels = new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
    int currentLabel = 1; 
    PImage result = createImage(input.width, input.height, RGB);
    
    colorMode(HSB, 100, 100, 100);
    
    // TODO!
    
    for(int i = 0; i < input.width*input.height; ++i) { // iterate over all pixels
    
      if(brightness(input.pixels[i]) == 100) { // if pixel is white
        int[] neighbors = neighbors(input, i, labels);

        if(sameLabels(neighbors)) {
          
          int firstInFrame = firstInFrame(neighbors);
          
          if(firstInFrame == 0 || firstInFrame == -1) { // if no labels yet
            labels [i] = currentLabel;
            ++currentLabel; 
            
            // add new label to equivalence set
            TreeSet<Integer> tree = new TreeSet<Integer>();
            tree.add(currentLabel - 1);
            labelsEquivalences.add(tree);}
            
           else { // if all have same index
             labels [i] = firstInFrame; }  
        }
        else {
          
          int smallestLabel = smallestLabel(neighbors, currentLabel);
          labels [i] = smallestLabel;
          
          // update equivalence classes
          for(int j = 0; j < neighbors.length; ++j) {
            if(neighbors[j] > 0) {
              labelsEquivalences.get(smallestLabel - 1).add(neighbors[j]);
              labelsEquivalences.get(neighbors[j] - 1).add(smallestLabel);
            }
          }
        }
      }
      else {
        labels [i] = 0; // otherwise label is 0 (no label)
      }
      
  
        
    }
      
   
    // Second pass: re-label the pixels by their equivalent class
    // if onlyBiggest==true, count the number of pixels for each label
    
    SortedMap<Integer, Integer> map = new TreeMap<Integer, Integer>();
    
    for(int i = 0; i < input.width*input.height; ++i) {
      if(brightness(input.pixels[i]) == 100) { // if pixel is white
        labels[i] = labelsEquivalences.get(labels[i] - 1).first();  
        if(onlyBiggest) {
          if(map.containsKey(labels[i])) {
            int newVal = map.get(labels[i]) + 1;
            map.replace(labels[i], newVal);
          }
          else {
            map.put(labels[i], 1);
          }
      }
      }
    }
    colorMode(RGB);
    
    if(!onlyBiggest) {
      
      color[] colors = new color[labelsEquivalences.size()];
      for(int i = 0; i < labelsEquivalences.size(); ++i) {
        do {
          colors[i] = color(random(255), random(255), random(255));
        } while(colors[i] == color(0, 0, 0));
      }
      
      for(int i = 0; i < input.width*input.height; ++i) {
        if(brightness(input.pixels[i]) == 100) {
          result.pixels[i] = colors[labels[i] - 1];
        }
        else {
          result.pixels[i] = color(0, 0, 0);
        }
      }
    }
    
    
    else {
      int largestBlobLabel = 0;
      int mostPixels = 0;
      List<Integer> keys = new ArrayList<Integer>(map.keySet());
      for(int i = 0; i < keys.size(); ++i) {
        if(map.get(keys.get(i)) >= mostPixels) {
          mostPixels = map.get(keys.get(i));
          largestBlobLabel = keys.get(i);
        }
      }
      
      for(int i = 0; i < input.width * input.height; ++i) {
        if(labels[i] == largestBlobLabel) {
          result.pixels[i] = color(255, 255, 255);
        }
        else {
          result.pixels[i] = color(0, 0, 0);
        }
        
      }

      
    }

            
    // Finally:  
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob in white and others in black

    // TODO!
    
    return result;
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
  
  // returns the smallest label in an array of neighbors
  int smallestLabel(int[] neighbors, int currentLabel) {
    int smallest = currentLabel + 1;
    for(int i = 0; i < neighbors.length ; ++i) {
      if(neighbors[i] > 0 && neighbors[i] < smallest) {
        smallest = neighbors[i];
      }
    }
    
    return smallest;
    
  }
  
}
