import processing.video.*;

Capture video; 

float[][] kernel = {{ -1, 0, 1}, 
                    { -2, 0, 2}, 
                    { -1, 0, 1}};

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
}