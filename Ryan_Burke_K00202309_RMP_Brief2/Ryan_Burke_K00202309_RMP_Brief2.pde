import processing.video.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput audioInput;
Capture video; 


void setup(){
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
  minim = new Minim(this);
  audioInput = minim.getLineIn();
}

void draw(){
  if(video.available()){
    video.read();
  }
  
  video.loadPixels();
  image(video, 0, 0);
  
  if(audioInput.left.level()*100 >= 15){
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
        ellipse(shapeX, shapeY,random(5,20), random(5, 20));
      }
      else
      {
        rect(shapeX,shapeY,random(5,20), random(5,20));
      }
    }
  }
  }
}