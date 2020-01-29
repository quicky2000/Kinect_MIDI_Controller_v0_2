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

// Pseudo MIDI output

class MidiOutput
{
  String m_name;
  int m_previous_channel;
  int m_previous_cc;
  int m_previous_value;
  
  MidiOutput(String p_name)
  {
    m_name = p_name;
    m_previous_channel = 0;
    m_previous_cc = 0;
    m_previous_value = 0;
  }
  
  void sendController(int p_channel, int p_cc, int p_value)
  {
    if(p_channel != m_previous_channel || p_cc != m_previous_cc || p_value != m_previous_value)
    {
      System.out.println("----------------------");
      System.out.println("Device \"" + m_name + "\" sendController(Channel " + p_channel + " CC " + p_cc + " Value " + p_value +")");
      m_previous_channel = p_channel;
      m_previous_cc = p_cc;
      m_previous_value = p_value;
    }
  }

  void sendNoteOn(int p_channel, int p_pitch, int p_velocity)
  {
    m_previous_channel = 0;
    m_previous_cc = 0;
    m_previous_value = 0;
    System.out.println("Device \"" + m_name + "\" sendNoteOn(Channel " + p_channel + " Pitch " + p_pitch + " Velocity " + p_velocity +")"); 
  }

  void sendNoteOff(int p_channel, int p_pitch, int p_velocity)
  {
    m_previous_channel = 0;
    m_previous_cc = 0;
    m_previous_value = 0;
    System.out.println("Device \"" + m_name + "\" sendNoteOff(Channel " + p_channel + " Pitch " + p_pitch + " Velocity " + p_velocity + ")"); 
  }
}
