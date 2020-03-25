import processing.video.*;

Movie video;

Tracker tracker;


Blob [] blobs;

float frontAngle = 0.0;

void setup() {

  size(640, 480);
  video = new Movie(this, "IR_test_video_3_dots_v1_640x480.mp4");
  video.play();

  
  tracker = new Tracker();
  
  // TRACKER SETTINGS
  tracker.brightThreshold = 200;      // min brightness for the pixels that can belong to a blob
  //tracker.distThreshold = 5;
  tracker.minNrOfPixels = 5;       // min nr of pixels belonging to the blob
  //tracker.maxNrOfPixels = 500;      // max nr of pixels belonging to the blob
  tracker.minArea = 4;            // min area (w*h) of bounding box
  //tracker.maxArea = 1000;           // max area (w*h) of bounding box
  tracker.minWidth = 2;            // min width for bounding box
  //tracker.maxWidth = 50;            // min width for bounding box
  tracker.minHeight = 2;           // min height for bounding box
  //tracker.maxHeight = 50;           // max height for bounding box
  //tracker.pixelToAreaRatio = 0.5;   // ratio of pixels in the bounding box that needs to belongs to the blob in order for it to count 1.0 means all pixels 
  //tracker.widthToHeightRatio = 0.4; // ratio of how squared the bounding box must be. 0.0 is perfect square

}

void movieEvent(Movie m) {
  m.read();
}

void draw() {

  video.loadPixels();
  image(video, 0, 0);
  if (video.time() > video.duration() -2){ // rewind video
    video.jump(0);
  }
  println("Video time", video.time(), "/", video.duration());
  
  tracker.update(video); // upcates the tracker with newest video frame
  //tracker.show(); // visualizes all blobs from the tracker object
  
  
  // example of how to extract blob info from the tracker class
  blobs = tracker.getBlobs();
  
  
  // check that we only have two blobs
  if (blobs.length == 3){
    
    // initialize back point
    PVector backPoint = new PVector(); 
    
    // traverse the three blob points
    for (int i = 0; i < blobs.length; i++){
      
      // get angle between current blob and the two other
      float angleBetween = getAngleBetween(blobs[i].center.x, blobs[i].center.y, blobs[(i+1)%3].center.x, blobs[(i+1)%3].center.y, blobs[(i+2)%3].center.x, blobs[(i+2)%3].center.y);
      
      // check if the current blob is the back point
      if (angleBetween > 100) {
        fill(255);
        noStroke();
        ellipse(blobs[i].center.x, blobs[i].center.y, 15, 15);
        backPoint = blobs[i].center; // save back point for visualization later
        float rotationA = getRotation(blobs[i].center.x, blobs[i].center.y, blobs[(i+1)%3].center.x, blobs[(i+1)%3].center.y); // rotation of one of the side points
        float rotationB = getRotation(blobs[i].center.x, blobs[i].center.y, blobs[(i+2)%3].center.x, blobs[(i+2)%3].center.y); // rotation of the other side point
        
        // calculate and set the rotation angle
        if (abs(rotationA-rotationB) > 150){ // anti clockwise rotation
          frontAngle = min(rotationA, rotationB) - 120/2;
          if (frontAngle < 0) frontAngle = 360+frontAngle; 
        }
        else frontAngle = min(rotationA, rotationB) + 120/2; // clock wise rotation
        
      }
      blobs[i].show(); // visualize current blob
    
    }
    
    // visualize view direction (frontAngle)
    pushMatrix();
    translate(backPoint.x, backPoint.y);
    rotate(radians(frontAngle));
    line(0,0,0,-30);
    popMatrix();
    
    textSize(20);
    text("FRONT ANGLE: " + round(frontAngle) + "°", 10, 30); 
    
    println();
  }
  
}


// method that calculates rotation of one point around another
float getRotation(float x1, float y1, float x2, float y2){
  
  PVector a = new PVector(x1, y1);   // point a
  PVector b = new PVector(x2, y2);   // point b
  PVector r = new PVector(0, -100);  // reference point
 
  b.sub(a);             // move point b
  a.sub(a);             // move point a
  
  // calculate rotation
  float angle = degrees(r.angleBetween(r,b));
  if (b.x < 0){ // turn result around if b is on the left side of a
    angle = 360 - angle;  
  }
  return angle; // return angle
}


// method that calculates the angle from point (a_x, a_x) and to the two other points (b_x, b_y) & (c_x, c_y)
float getAngleBetween(float a_x, float a_y, float b_x, float b_y, float c_x, float c_y){
  
  PVector a = new PVector(a_x, a_y);   // point a
  PVector b = new PVector(b_x, b_y);   // point b
  PVector c = new PVector(c_x, c_y);   // point c
  //PVector r = new PVector(0, -100);  // reference point
 
  c.sub(a);             // move point c
  b.sub(a);             // move point b
  a.sub(a);             // move point a to zero
    
  // calculate angle
  float angle = degrees(PVector.angleBetween(b,c));
  
  return angle; // return angle
}
