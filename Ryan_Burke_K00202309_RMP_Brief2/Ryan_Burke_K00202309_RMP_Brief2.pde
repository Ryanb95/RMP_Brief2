import processing.video.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import javax.swing.JOptionPane;

Minim minim;
AudioInput audioInput;
Capture video; 

ArrayList frames = new ArrayList();
XML xml;

void setup(){
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
  minim = new Minim(this);
  audioInput = minim.getLineIn();
  xml = loadXML("message.xml");
  XML[] messages = xml.getChildren("message");
  for(int i = 0; i < messages.length; i++){
    String alert = messages[i].getString("text");
    JOptionPane.showMessageDialog(null,alert);
  }
}

void captureEvent(Capture video){
  video.read();
  
  PImage image = createImage(width, height, RGB);
  video.loadPixels();
  arrayCopy(video.pixels, image.pixels);
  
  frames.add(image);
  
  if(frames.size() > height/4){
    frames.remove(0);
  }
}

void draw(){
  int currentImage = 0;
  
  loadPixels();
  
  image(video, 0, 0);
 
  if(mousePressed){
      for (int y = 0; y < video.height; y+=5 ) {
        if(currentImage < frames.size()){
          PImage image = (PImage)frames.get(currentImage);
          
          if(image != null){
            image.loadPixels();
            
            for(int x = 0; x < video.width; x++){
              pixels[x + y * width] = image.pixels[x + y * video.width];
              pixels[x + (y + 1) * width] = image.pixels[x + (y + 1) * video.width];
              pixels[x + (y + 2) * width] = image.pixels[x + (y + 2) * video.width];
              pixels[x + (y + 3) * width] = image.pixels[x + (y + 3) * video.width];
              pixels[x + (y + 4) * width] = image.pixels[x + (y + 3) * video.width];
            }
          }
          
          currentImage++;
          
        }
        
        else{
          break;
        }
  }
  
  updatePixels();
  }
  
  if(((audioInput.left.level()*100) > 20)){
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