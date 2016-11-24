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
      for (int y = 0; y < video.height; y+=4 ) {
        if(currentImage < frames.size()){
          PImage image = (PImage)frames.get(currentImage);
          
          if(image != null){
            image.loadPixels();
            
            for(int x = 0; x < video.width; x++){
              pixels[x + y * width] = image.pixels[x + y * video.width];
              pixels[x + (y + 1) * width] = image.pixels[x + (y + 1) * video.width];
              pixels[x + (y + 2) * width] = image.pixels[x + (y + 2) * video.width];
              pixels[x + (y + 3) * width] = image.pixels[x + (y + 3) * video.width];
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
}