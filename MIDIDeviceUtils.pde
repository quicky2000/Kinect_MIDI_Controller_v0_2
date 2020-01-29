static class MIDIDeviceUtils
{
  static void printMIDIDevices()
  {
    // Initialise MIDI
    println("Input devices:");
    println(RWMidi.getInputDevices());
    println();
    println("Output devices:");
    println(RWMidi.getOutputDevices());
    println();
  }
  
  static String getOutputDeviceName(int deviceIndex)
  {
    return RWMidi.getOutputDevices()[deviceIndex].getName();
  }
  
  // Return a mapping of all the pitches on a device
  static int[] getPitches(int device)
  {
    switch (device)
    {
      case Devices.Generic:
        int numNotes = 64;
        int startPitch = 32;
        int[] genericNotes = new int[numNotes];
        for (int i = startPitch; i < (startPitch + numNotes); i++)
        {
          genericNotes[i - startPitch] = i;
        }
        return genericNotes;
      
      case Devices.Launchpad:
        int[] launchpadNotes = {
          64, 65, 66, 67, 96, 97, 98, 99,
          60, 61, 62, 63, 92, 93, 94, 95,
          56, 57, 58, 59, 88, 89, 90, 91,
          52, 53, 54, 55, 84, 85, 86, 87,
          48, 49, 50, 51, 80, 81, 82, 83,
          44, 45, 46, 47, 76, 77, 78, 79,
          40, 41, 42, 43, 72, 73, 74, 75,
          36, 37, 38, 39, 68, 69, 70, 71};
        return launchpadNotes;
        
      case Devices.LaunchpadQuadrantMode:
        int[] launchpadQuadrantModeNotes = {
          64, 64, 64, 64, 65, 65, 65, 65,
          64, 64, 64, 64, 65, 65, 65, 65,
          64, 64, 64, 64, 65, 65, 65, 65,
          64, 64, 64, 64, 65, 65, 65, 65,
          60, 60, 60, 60, 61, 61, 61, 61,
          60, 60, 60, 60, 61, 61, 61, 61,
          60, 60, 60, 60, 61, 61, 61, 61,
          60, 60, 60, 60, 61, 61, 61, 61};
        return launchpadQuadrantModeNotes;
    }
    
    return null;
  }
  
  // Return the pitch of a single button on a device
  static int getPitch(int device, int index)
  {
    if (index == -1) return -1;
    
    int[] pitches = MIDIDeviceUtils.getPitches(device);
    if (pitches == null || pitches.length <= index) return -1;
   
    return pitches[index - 1];
  }
  
  // Return all the pitches for a quadrant based on the pitch
  static int[] getQuadrantPitches(int device, int pitch)
  {
    if (pitch == -1) return null;
    
    switch (device)
    {
      case Devices.LaunchpadQuadrantMode:
        // 1 2
        // 3 4
        if (pitch == 64)   // Quadrant 1
        {
          int[] customDevicePitches1 = {
            64, 65, 66, 67,
            60, 61, 62, 63,
            56, 57, 58, 59,
            52, 53, 54, 55};
          return customDevicePitches1;
        }
        else if (pitch == 65)   // Quadrant 2
        {
          int[] customDevicePitches2 = {
            96, 97, 98, 99,
            92, 93, 94, 95,
            88, 89, 90, 91,
            84, 85, 86, 87};
          return customDevicePitches2;
        }
        else if (pitch == 60)   // Quadrant 3
        {
          int[] customDevicePitches3 = {
            48, 49, 50, 51,
            44, 45, 46, 47,
            40, 41, 42, 43,
            36, 37, 38, 39};
          return customDevicePitches3;
        }
        else if (pitch == 61)   // Quadrant 4
        {
          int[] customDevicePitches4 = {
            80, 81, 82, 83,
            76, 77, 78, 79,
            72, 73, 74, 75,
            68, 69, 70, 71};
          return customDevicePitches4;
        }
    }
    
    return null;
  }
  
  // Return all the indices for a quadrant based on the index
  static ArrayList getQuadrantIndices(int device, int index)
  {
    if (index == -1) return null;
    
    switch (device)
    {
      case Devices.LaunchpadQuadrantMode:
        // 1 2
        // 3 4
        
        // Create arrays of indices
        ArrayList customDeviceIndices1 = new ArrayList();
        ArrayList customDeviceIndices2 = new ArrayList();
        ArrayList customDeviceIndices3 = new ArrayList();
        ArrayList customDeviceIndices4 = new ArrayList();
        
        int i = 1;
        for (int x = 1; x <= 8; x++)
        {
          for (int y = 1; y <= 8; y++)
          {
            if (y <= 4)
            {
              if (x <= 4) customDeviceIndices1.add(i);
              else customDeviceIndices2.add(i);
            }
            else
            {
              if (x <= 4) customDeviceIndices3.add(i);
              else customDeviceIndices4.add(i);
            }
            
            i++;
          }
        }

        if (customDeviceIndices1.contains(index)) return customDeviceIndices1;
        else if (customDeviceIndices2.contains(index)) return customDeviceIndices2;
        else if (customDeviceIndices3.contains(index)) return customDeviceIndices3;
        else if (customDeviceIndices4.contains(index)) return customDeviceIndices4;
    }
   
    return null; 
  }
}
