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
  
  PImage sobel = createImage(video.width, video.height, RGB);
  
  for (int y = 1; y < video.height-1; y++){
    for (int x = 1; x < video.width-1; x++){
      float sum = 0;
      for (int sy = -1; sy <= 1; sy++){
        for (int sx = -1; sx <= 1; sx++){
          int pos = (y + sy) * video.width + (x + sx);
          float val = red(video.pixels[pos]);
          sum += kernel[sy+1][sx+1] * val;
        }
      }
      
      sobel.pixels[y*video.width + x] = color(sum, sum, sum);
    }
  }
  
  sobel.updatePixels();
  image(sobel, 0, 0);
}