  /*
  *  blob_detection.pde  
  *  Classe pour gérer la détection de blobs
  *  Groupe Q : 
  *     BIANCHI Elisa 300928     ;
  *     DENOVE Emmanuelle 301576 ;
  *     RIEUPOUILH Louise 299418 ;
  */

import java.util.ArrayList;
import java.util.SortedMap;
import java.util.List; 
import java.util.TreeSet;
import java.util.Map;
import java.util.TreeMap; 

class BlobDetection {
  
  // méthode principale pour détecter les blobs
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    
    int [] labels = new int [input.width*input.height]; // aray pour contenir le label de chaque pixel
    List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>(); // liste d'équivalence des labels
    int currentLabel = 1; 
    PImage result = createImage(input.width, input.height, RGB); // image finale, d'abord transparente
    
    colorMode(HSB, 100, 100, 100);
    
    for(int i = 0; i < input.width*input.height; ++i) { // itération sur tous les pixels
    
      if(brightness(input.pixels[i]) == 100) { // si le pixel est blanc
      
        int[] neighbors = neighbors(input, i, labels); // tableau des labels des 4 voisins concernés

        if(sameLabels(neighbors)) { // si tous les voisins ont le même label
          
          int firstInFrame = firstInFrame(neighbors);
          
          if(firstInFrame == 0 || firstInFrame == -1) { // s'il n'y a pas encore de labels
            labels [i] = currentLabel;
            ++currentLabel; 
            
            // on crée un nouveau label et on le rajoute à la liste d'équivalences
            TreeSet<Integer> tree = new TreeSet<Integer>();
            tree.add(currentLabel - 1);
            labelsEquivalences.add(tree);}
            
           else { // sinon, on donne au pixel le même label que ses voisins
             labels [i] = firstInFrame; }  
        }
        
        else { // si les labels des voisins ne sont pas tous les mêmes
          
          int smallestLabel = smallestLabel(neighbors, currentLabel); 
          labels [i] = smallestLabel; // on donne au pixel le label le plus petit de ceux donnés aux voisins
          
          // mise à jour des listes d'équivalences
          for(int j = 0; j < neighbors.length; ++j) {
            if(neighbors[j] > 0) {
              labelsEquivalences.get(smallestLabel - 1).add(neighbors[j]);
              labelsEquivalences.get(neighbors[j] - 1).add(smallestLabel);
            }
          }
        }
      }
      else {
        labels [i] = 0; // si le pixel n'est pas blanc, son label est mis à 0
      }
      
  
        
    }
      
    // mise à jour de la liste des équivalences
    
    for(int i = 0; i < labelsEquivalences.size(); ++i) { // itération sur tous les sets de labels
     for(int j = 0; j < currentLabel - 1; ++j) {  // itération sur tous les labels possible
     
       if(labelsEquivalences.get(i).contains(j)) { // si le set actuel contient le label j
         
          for(int k = 0; k < labelsEquivalences.get(j).size(); ++k) {  // itération sur tous les labels dans la classe d'équivalence de j
            if(!(labelsEquivalences.get(i).contains((labelsEquivalences.get(j).toArray())[k]))) { // si le set actuel ne contient pas encore un label dans cette classe d'équivalence
              int num = (int) labelsEquivalences.get(j).toArray()[k];
               labelsEquivalences.get(i).add(num); // on l'ajoute au set actuel
            }
          }
       }
     }
    }
   
    // deuxième itération sur tous les pixels
    
    SortedMap<Integer, Integer> map = new TreeMap<Integer, Integer>();
    
    for(int i = 0; i < input.width*input.height; ++i) {
      
      if(brightness(input.pixels[i]) == 100) { // si le pixel est blanc
        labels[i] = labelsEquivalences.get(labels[i] - 1).first();  // on set le label au label le plux petit dans sa liste d'équivalences
        
        if(onlyBiggest) { // si onlyBiggest est vrai
        
         // dans map, on associe chaque label au nombre de pixels ayant ce label
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
    
    if(!onlyBiggest) { // si onlyBiggest est faux
      
      color[] colors = new color[labelsEquivalences.size()]; // on crée un tableau de couleurs
      for(int i = 0; i < labelsEquivalences.size(); ++i) {
        do {
          colors[i] = color(random(255), random(255), random(255)); // on associe une couleur au hasard (qui n'est pas noir) à chaque label possible
        } while(colors[i] == color(0, 0, 0));
      }
      
      // association de chaque pixel à la couleur de son label
      for(int i = 0; i < input.width*input.height; ++i) {
        if(brightness(input.pixels[i]) == 100) {
          result.pixels[i] = colors[labels[i] - 1];
        }
        else {
          result.pixels[i] = color(0, 0, 0);
        }
      }
    }
    
    
    else { // si onlyBiggest est vrai
      int largestBlobLabel = 0;
      int mostPixels = 0;
      
      // extraction du label ayant le plus de pixels
      List<Integer> keys = new ArrayList<Integer>(map.keySet());
      for(int i = 0; i < keys.size(); ++i) {
        if(map.get(keys.get(i)) >= mostPixels) {
          mostPixels = map.get(keys.get(i));
          largestBlobLabel = keys.get(i);
        }
      }
      
      // itération sur tous les pixels
      for(int i = 0; i < input.width * input.height; ++i) {
        
        if(labels[i] == largestBlobLabel) { // si le pixel è le label le plus utilisé, on le set à blanc
          result.pixels[i] = color(255, 255, 255);
        }
        else {
          result.pixels[i] = color(0, 0, 0); // sinon, on le set à noir
        }
        
      }

      
    }
    
    return result;
  } 


  // méthode auxiliaire pour extraire les 4 voising concernés du pixel d'index currentIndex
  int [] neighbors(PImage img, int currentIndex, int [] labels) {
    
      int [] res = new int[4]; // tableau qui contiendra les labels de tous les voisins
      for(int i = 0; i < 4; ++i) { res [i] = -1; } // on itialise tous les voisins à -1 (ce qui signifie qu'il n'est pas dans l'image
      
      int x = currentIndex % img.width;
      int y = currentIndex/img.width;
      
      // pour chaque voisin, on teste s'il est dans l'image, et si oui, on met son label dans le tableau
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
  
  // méthode auxiliauire qui retourne si tous les labels de pixels non noirs qui sont dans l'image sont les mêmes
  boolean sameLabels(int [] neighbors) {
    int current = -2;
    
    for(int i = 0; i < neighbors.length ; ++i) { // itération sur tous les voisins
      
      if(neighbors[i] != -1 && neighbors[i] != 0 && neighbors[i] != current) { 
        if(current != -2) { return false; }
        else { current = neighbors[i]; }
      }
  
    }
    return true;
  }
  
  
  // méthode auxiliaire qui retourne le premier label non noir dans l'image, et -1 s'il n'y en a pas
  int firstInFrame(int [] neighbors) { 
    
    for(int i = 0; i < neighbors.length; ++i) {
      if(neighbors[i] != -1 && neighbors[i] != 0) {
        return neighbors[i];
      }
    }
    
    return -1;
  }
  
  // retourne le plus petit label dans un array de voisins
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
