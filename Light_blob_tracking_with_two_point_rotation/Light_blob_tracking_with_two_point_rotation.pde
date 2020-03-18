import processing.video.*;

Capture video;

Tracker tracker;


Blob [] blobs;

float rotation;

void setup() {

  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    video = new Capture(this, cameras[0]);
    video.start();
  }
  
  
  tracker = new Tracker();
  
  // TRACKER SETTINGS
  tracker.brightThreshold = 240;      // min brightness for the pixels that can belong to a blob
  //tracker.minNrOfPixels = 20;       // min nr of pixels belonging to the blob
  //tracker.maxNrOfPixels = 500;      // max nr of pixels belonging to the blob
  //tracker.minArea = 100;            // min area (w*h) of bounding box
  //tracker.maxArea = 1000;           // max area (w*h) of bounding box
  //tracker.minWidth = 10;            // min width for bounding box
  //tracker.maxWidth = 50;            // min width for bounding box
  //tracker.minHeight = 10;           // min height for bounding box
  //tracker.maxHeight = 50;           // max height for bounding box
  //tracker.pixelToAreaRatio = 0.5;   // ratio of pixels in the bounding box that needs to belongs to the blob in order for it to count 1.0 means all pixels 
  //tracker.widthToHeightRatio = 0.4; // ratio of how squared the bounding box must be. 0.0 is perfect square

}

void captureEvent(Capture video) {
  video.read();
}



void draw() {

  video.loadPixels();
  image(video, 0, 0);
  
  
  tracker.update(video); // upcates the tracker with newest video frame
  //tracker.show(); // visualizes all blobs from the tracker object
  
  
  // example of how to extract blob info from the tracker class
  blobs = tracker.getBlobs();
  
  
  // check that we only have two blobs
  if (blobs.length == 2){
    
    float x1 = -1;
    float y1 = -1;
    float x2 = -1; 
    float y2 = -1;
    
    for (int i = 0; i < blobs.length; i++){
      
      println(blobs[i].center.x, blobs[i].center.y, blobs[i].nrOfPixels);
      
      // check if blob is the small light
      if (blobs[i].nrOfPixels < 150){
        blobs[i].pixelColor = color(255,0,0);
        x1 = blobs[i].center.x;
        y1 = blobs[i].center.y;
      }
      // else it is the big light
      else {
        blobs[i].pixelColor = color(0,0,255);
        x2 = blobs[i].center.x;
        y2 = blobs[i].center.y;        
      }
      blobs[i].show(); // visualizes blobs individually from the blob list returned from the tracker  
    }
    println();
    
    // check if both coordinates have been set
    if (x1 != -1 && y1 != -1 && x2 != -1 && y2 != -1){
      rotation = getRotation(x1, y1, x2, y2);
      println(rotation);
      // draw angle to the screen for debuggin purpose
      textSize(50);
      text(rotation, 10, 70);
    } 
    
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
