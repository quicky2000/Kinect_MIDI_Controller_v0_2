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

// Pseudo Kinect
// This class simulate a kinect by using Laptop webcam for video capture and mouse to interact on depth information

class Kinect
{
  int m_angle;
  boolean m_depth_enabled;
  int[] m_depth;
  PImage m_image;
  Capture video;
  int m_width;
  int m_height;
  int m_previous_mouse_X;
  int m_previous_mouse_Y;
  boolean m_was_pressed;
  
  Kinect(PApplet p_applet)
  {
    m_angle = 0;
    m_depth_enabled = false;
    m_width = p_applet.width;
    m_height = p_applet.height;
    m_depth = new int[m_width * m_height];
    m_image = new PImage(m_width, m_height, PConstants.RGB);
    video = new Capture(p_applet, m_width, m_height, Capture.list()[0]);
    for(int l_index = 0; l_index < m_width * m_height; ++l_index)
    {
      m_depth[l_index] = 880;
    }
   m_previous_mouse_X = 0;
   m_previous_mouse_Y = 0;
   m_was_pressed = false;
}
  
  void tilt(int p_angle)
  {
    m_angle = p_angle;
  }
  
  void start()
  {
    video.start();
  }
  
  void quit()
  {
  }
  
  void enableDepth(boolean p_enable)
  {
    m_depth_enabled = p_enable;
  }
  
  void processDepthImage(boolean p_bool)
  {
  }
  
  void treat_mouse(int p_mouse_X, int p_mouse_Y, int p_depth)
  {
    int l_min_X = p_mouse_X - 50;
        int l_max_X = p_mouse_X + 50;
        if(l_min_X < 0)
        {
          l_min_X = 0;
        }
        if(l_max_X > m_width)
        {
          l_max_X = m_width;
        }
        int l_min_Y = p_mouse_Y - 50;
        int l_max_Y = p_mouse_Y + 50;
        if(l_min_Y < 0)
        {
          l_min_Y = 0;
        }
        if(l_max_Y > m_height)
        {
          l_max_Y = m_height;
        }
        for(int l_y = l_min_Y ; l_y < l_max_Y; ++l_y)
        {
          for(int l_x = l_min_X ; l_x < l_max_X; ++l_x)
          {
            int l_index = (m_width - l_x - 1) + m_width * l_y;
            m_depth[l_index] = p_depth;
          }
        }
  }
  
  int[] getRawDepth()
  {
      if(mousePressed && mouseButton == LEFT)
      {
        if(mouseX != m_previous_mouse_X || mouseY != m_previous_mouse_Y)
        {
          treat_mouse(m_previous_mouse_X, m_previous_mouse_Y, 880);
          m_previous_mouse_X = mouseX;
          m_previous_mouse_Y = mouseY;
          treat_mouse(m_previous_mouse_X, m_previous_mouse_Y, 0);
          m_was_pressed = true;
        }
      }
      else if(m_was_pressed)
      {
        m_was_pressed = false;
        treat_mouse(m_previous_mouse_X, m_previous_mouse_Y, 880);
      }

    if(m_depth_enabled)
    {
      return m_depth;
    }
    else
    {
      return null;
    }
  }
  
  PImage getDepthImage()
  {
    if(video.available())
    {
       video.read();
    }
     return video;
  }
}
