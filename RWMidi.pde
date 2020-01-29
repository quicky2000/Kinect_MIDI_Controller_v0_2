//
//    Copyright (C) 2020  Julien Thevenon ( julien_thevenon at yahoo.fr )
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>
//

// Pseudo RWMidi lib that return MIDI peripherals

static 
class RWMidi
{
  static RWMidiOutput[] m_outputs = new RWMidiOutput[4];
  static String[] m_inputs = {new String("Micro")};
  static Kinect_MIDI_Controller_v0_2 m_applet;
  
  static RWMidiOutput[] getOutputDevices()
  {
    if(m_outputs[0] == null)
    {
      m_outputs[0] = m_applet.new RWMidiOutput ("Generic");
      m_outputs[1] = m_applet.new RWMidiOutput ("Launchpad");
      m_outputs[2] = m_applet.new RWMidiOutput ("LaunchpadQuadrantMode");
      m_outputs[3] = m_applet.new RWMidiOutput ("CustomDevice");
      //int device = Devices.Launchpad;
//int device = Devices.LaunchpadQuadrantMode;
//int device = Devices.CustomDevice;

    }
    return m_outputs;
  }
  static String[] getInputDevices()
  {
    return m_inputs;
  }
}
