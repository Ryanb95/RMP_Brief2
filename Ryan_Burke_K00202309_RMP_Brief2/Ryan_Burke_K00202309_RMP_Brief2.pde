import processing.video.*;

Capture video; 


void setup(){
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();
  frameRate(30);
}

void draw(){
  if(video.available()){
    video.read();
  }
  
  video.loadPixels();
  image(video, 0, 0);
  filter(GRAY);
}