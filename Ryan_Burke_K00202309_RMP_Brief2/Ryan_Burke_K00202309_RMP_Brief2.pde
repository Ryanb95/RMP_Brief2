import processing.video.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import javax.swing.JOptionPane;

//Creates objects of the Minim, AudioInput and Capture classes
Minim minim;
AudioInput audioInput;
Capture video; 

//Created an array which stores the frames of the video
ArrayList frames = new ArrayList();

//Created an object which can store xml
XML xml;

void setup(){
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
  minim = new Minim(this);
  audioInput = minim.getLineIn();
  
  //Loads xml int the xml object, reads the xml page and displays a pop up when window opens
  xml = loadXML("message.xml");
  XML[] messages = xml.getChildren("message");
  for(int i = 0; i < messages.length; i++){
    String alert = messages[i].getString("text");
    JOptionPane.showMessageDialog(null,alert);
  }
}

//Function that runs when a new camera frame is availale
void captureEvent(Capture video){
  video.read();
  
  //Copys current video frame so it can  be stored in the frames array
  PImage image = createImage(width, height, RGB);
  video.loadPixels();
  arrayCopy(video.pixels, image.pixels);
  
  frames.add(image);
  
  //Removes the oldest frame once there are enough captured
  if(frames.size() > height/4){
    frames.remove(0);
  }
}

void draw(){
  
  //Create an image counter, initialise it to 0
  int currentImage = 0;
  
  loadPixels();
  
  image(video, 0, 0);
 
  if(mousePressed){
    //Loops through rows of pixels which are 5 in height
      for (int y = 0; y < video.height; y+=5 ) {
        
        //Searches the frames array and retrieves an image, starting with the oldest
        if(currentImage < frames.size()){
          PImage image = (PImage)frames.get(currentImage);
          
          if(image != null){
            image.loadPixels();
            
            //Puts 5 pixel rows on the sketch
            for(int x = 0; x < video.width; x++){
              pixels[x + y * width] = image.pixels[x + y * video.width];
              pixels[x + (y + 1) * width] = image.pixels[x + (y + 1) * video.width];
              pixels[x + (y + 2) * width] = image.pixels[x + (y + 2) * video.width];
              pixels[x + (y + 3) * width] = image.pixels[x + (y + 3) * video.width];
              pixels[x + (y + 4) * width] = image.pixels[x + (y + 3) * video.width];
            }
          }
          
          //Increment the image counter by one
          currentImage++;
          
        }
        
        else{
          break;
        }
  }
  
  updatePixels();
  }
  
  //Detects audio input
  if(((audioInput.left.level()*100) > 20)){
    
    //Loops through the pixels of the video and draws random squares and circles
    //When noise is detected
    for (int y = 0; y < video.height; y+=10 ) {
    for (int x = 0; x < video.width; x+=10 ) {
      
      int imgloc = x + y*video.width;
      
      float r = red(video.pixels[imgloc]);
      float g = green(video.pixels[imgloc]);
      float b = blue(video.pixels[imgloc]);

      fill(r,g,b, 130);
      noStroke();
      int choice = (int)random(2);
      
      int shapeX, shapeY;
      shapeX = x + (width - video.width)/2;
      shapeY = y + (height - video.height)/2;
      
      shapeX += random(-5,5);
      shapeY += random(-5,5);
      
      if (choice == 0) {
        ellipse(shapeX, shapeY,random(5,15), random(5,15));
      }
      else
      {
        rect(shapeX,shapeY,random(5,15), random(5,15));
      }
    }
  }
  }
}