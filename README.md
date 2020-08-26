# Sound_dive
  
  An interactive, augmented virtuality experience powered by spatial audio and kinect motion tracking.
  
  Part of a bachelors project at the IT University of Copenhagen.
  Developed as part of a collaboration between AIR LAB at ITU, and CATCH.
  
  Kinect tracking code by: Halfdan Hauch Jensen, halj@itu.dk, AIR LAB, IT University of Cph.
  
  SoundDive by: Emil Vogt Sørensen, emvs@itu.dk and Frederic Widding, frew@itu.dk
  
 ## Requires:
  
  - Open Kinect for Processing
  - Processing Video
  - The MidiBus
  
  For details abou Headset setup:
  https://airlab.itu.dk/orientation-and-position-tracking/

## How to set up Kinect Tracking for Windows 10, 64bit:
 
 1) Download and install Kinect 1.7 SDK
 2) Download Zadig and replace the drivers for
       Xbox NUI Camera
       Xbox NUI Motor
       Kinect Audio Device
    with LibusbK.
 
 The kinect should now work. If the error "Isochronous transfer error: 1" appears, don't panic, it should work. If screen remains grey, try restarting the sketch a couple of times.
 
 ## Hotkeys
 
 M - Toggle manual mode (on by default). Swaps player to mouse movement and allows for manual turning and Z adjustment
 Shift - Traverse dowh on Z-axis (only with Manual Mode)
 Space - Traverse up on Z-axis (only with Manual Mode)
 Q - Rotate left (only with Manual Mode)
 E - Rotate left (only with Manual Mode)

