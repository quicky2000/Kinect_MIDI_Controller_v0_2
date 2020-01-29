//TO RESTORE import rwmidi.*;

class MIDI
{
  MidiOutput output;
  int outputDeviceId = 0;
  
  void init()
  {
    output = RWMidi.getOutputDevices()[outputDeviceId].createOutput();
  }
  
  void sendController(int channel, int cc, int value)
  {
    if (channel == -1) return;
    output.sendController(channel, cc, value);
  }
  
  void noteOn(int channel, int pitch, int velocity)
  {
    if (channel == -1 || pitch == -1) return;
    output.sendNoteOn(channel, pitch, velocity);
  }
  
  void noteOnArray(int channel, int[] pitches, int velocity)
  {
    if (channel == -1 || pitches == null) return;
    
    for (int i = 0; i < pitches.length; i++)
    {
      noteOn(channel, pitches[i], velocity);
    }
  }
  
  void noteOff(int channel, int pitch, int velocity)
  {
    if (channel == -1 || pitch == -1) return;
    output.sendNoteOff(channel, pitch, velocity);
  }
  
  void noteOffArray(int channel, int[] pitches, int velocity)
  {
    if (channel == -1 || pitches == null) return;
    
    for (int i = 0; i < pitches.length; i++)
    {
      noteOff(channel, pitches[i], velocity);
    }
  }
}
