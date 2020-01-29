// Kinect MIDI Controller v0.2
// by Ben X Tan
// http://kmidic.com
// http://benxtan.com
// Last modified on 02 May 2011

import org.openkinect.*;
import org.openkinect.processing.*;

// ----------------------------------------------------------------------------------------------------
// Settings
// ----------------------------------------------------------------------------------------------------

boolean useKinect = true;
boolean showGrid = true;

int midiOutputDeviceId = 0;
int launchpadOutputDeviceId = 1;
int device = Devices.Generic;
//int device = Devices.Launchpad;
//int device = Devices.LaunchpadQuadrantMode;
//int device = Devices.CustomDevice;

// Set these values to output a CC value based on the area of your hand
int ccChannel = 0;
int cc = 28;   // Set to -1 to disable

// ----------------------------------------------------------------------------------------------------

// Kinect
Kinect kinect;
KinectTracker tracker;

int kinectAngle =  0;

// Grid
Grid grid;

// MIDI
MIDI midi;
MIDI launchpadMIDI;
String midiOutputDeviceName = MIDIDeviceUtils.getOutputDeviceName(midiOutputDeviceId);

int currentIndex = -1;
int currentPitch = -1;
boolean isMute = false;

// ----------------------------------------------------------------------------------------------------

void setup()
{
  size(640, 520);
  
  // Debugging
  MIDIDeviceUtils.printMIDIDevices();
  println("Output Device: " + midiOutputDeviceName);
  
  // Initialise grid
  grid = new Grid();
  grid.offsetX = (width - grid.getGridWidth()) / 2;
  grid.offsetY = (480 - grid.getGridWidth()) / 2;;
  grid.init();
  
  // Initialise MIDI
  midi = new MIDI();
  midi.outputDeviceId = midiOutputDeviceId;
  midi.init();
  
  if (device == Devices.Launchpad
    || device == Devices.LaunchpadQuadrantMode)
  {
    launchpadMIDI = new MIDI();
    launchpadMIDI.outputDeviceId = launchpadOutputDeviceId;
    launchpadMIDI.init();
  }
  
  // Initialise Kinect
  if (useKinect)
  {
    kinect = new Kinect(this);
    tracker = new KinectTracker();
    tracker.threshold = 570;
    kinect.tilt(kinectAngle);
  }
}

void draw()
{
  background(200);
  
  PVector vector = null;
  
  if (useKinect)
  {
    // Run the tracking analysis
    tracker.track();
  
    // Show the image
    tracker.display();

    // Let's draw the raw location
    PVector v1 = tracker.getPos();
    noStroke();
    fill(50, 100, 250, 200);   // Blue
    ellipse(v1.x, v1.y, 20, 20);
  
    // Let's draw the "lerped" location
    vector = tracker.getLerpedPos();
    noStroke();
    fill(100, 250, 50, 200);   // Green
    ellipse(vector.x, vector.y, 20, 20);
  
    // Display some info
    int kinectThreshold = tracker.getThreshold();
    fill(0);
    text((isMute ? "[MUTED]" : "") +  " " 
      + "Framerate: " + (int)frameRate + "  "
      + "Tilt: " + kinectAngle + "  "
      + "Threshold: " + kinectThreshold + " "
      + "     "
      + "[M = Mute, Up/Down = Tilt, Left/Right = Threshold]", 10, 505);
  }

  // Draw the grid
  if (showGrid) grid.drawGrid();
  
  if (vector != null)
  {
    // Grid and MIDI functionality
    int index = grid.getIndex(vector.x, vector.y);

    if (showGrid)
    {
      if (device == Devices.LaunchpadQuadrantMode)
      {
        ArrayList indices = MIDIDeviceUtils.getQuadrantIndices(device, index);
        grid.lightBoxes(indices);
      }
      else
      {
        grid.lightBox(index);
      }
    }
    
    doMIDI(index);
  }
  
  // Output the MIDI output device name
  fill(255);
  text(midiOutputDeviceName, 5, 15);
}

void doMIDI(int index)
{
  if (isMute)
  {
    // Check if there is a note playing
    if (currentPitch != -1)
    {
      // If quadrants are used
      if (device == Devices.LaunchpadQuadrantMode)
      {
        // Turn off all notes on the Launchpad
        launchpadMIDI.noteOffArray(0, MIDIDeviceUtils.getPitches(Devices.LaunchpadQuadrantMode), 127);
      }

      // Turn off the note that is playing
      midi.noteOff(0, currentPitch, 0);
      
      currentPitch = -1;
    }
  
    return;
  }
  
  // Controller values
  if (cc != -1)
  {
    int maxArea = 15000;   // Roughly the size of my hand
    int area = (tracker.area > maxArea) ? maxArea : tracker.area;
    int ccValue = (int) map(area, 0, 15000, 0, 127);
    midi.sendController(ccChannel, cc, ccValue);
    //print(tracker.area + ",");
    //print(ccValue + ",");
  }
  
  // Pitch
  int pitch = MIDIDeviceUtils.getPitch(device, index);
  
  // Check if there is a new note to play and it is different from the last note
  if (pitch != -1 && currentPitch != pitch)
  {
    // Turn off the last note if there is one
    if (currentPitch != -1)
    {
      if (device == Devices.LaunchpadQuadrantMode)
      {
        // Turn off all the lights on the launchpad
        launchpadMIDI.noteOffArray(0, MIDIDeviceUtils.getPitches(Devices.Launchpad), 127);
      }

      midi.noteOff(0, currentPitch, 0);
    }
    
    // Send MIDI note
    currentPitch = pitch;
    int velocity = 127;
    midi.noteOn(0, currentPitch, velocity);
    
    if (device == Devices.LaunchpadQuadrantMode)
    {
      // Turn on lights on the launchpad
      launchpadMIDI.noteOnArray(0, MIDIDeviceUtils.getQuadrantPitches(device, currentPitch), velocity);
    }
  }
  
  // Check if there is no new note to play and if we need to turn off the last note
  else if (pitch == -1 && currentPitch != -1)
  {
    if (device == Devices.LaunchpadQuadrantMode)
    {
      // Turn off all the lights on the launchpad
      launchpadMIDI.noteOffArray(0, MIDIDeviceUtils.getPitches(Devices.Launchpad), 127);
    }

    midi.noteOff(0, currentPitch, 0);
    
    currentPitch = -1;
  }
}

void keyPressed()
{
  int t = tracker.getThreshold();
  if (key == CODED)
  {
    if (keyCode == UP)
    {
      kinectAngle++;
      kinectAngle = constrain(kinectAngle, 0, 30);
      kinect.tilt(kinectAngle);
    }
    else if (keyCode == DOWN)
    {
      kinectAngle--;
      kinectAngle = constrain(kinectAngle, 0, 30);
      kinect.tilt(kinectAngle);
    }
    else if (keyCode == RIGHT)
    {
      t += 5;
      tracker.setThreshold(t);
    } 
    else if (keyCode == LEFT)
    {
      t -= 5;
      tracker.setThreshold(t);
    }
  }
  else if (key == 'm')
  {
    isMute = !isMute;
  }
}

void stop()
{
  if (device == Devices.Launchpad
    || device == Devices.LaunchpadQuadrantMode)
  {
    launchpadMIDI.noteOffArray(0, MIDIDeviceUtils.getPitches(Devices.Launchpad), 127);
  }
  
  tracker.quit();
  super.stop();
}
