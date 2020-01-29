class Grid
{
  int offsetX = 0;
  int offsetY = 0;
  int gridSize = 8;
  int gridPadding = 2;
  int boxWidth = 50;
  int boxHeight = 50;
  int mapping = Devices.Launchpad;

  int highlightColor = color(0, 255, 0, 100);
  
  void init()
  {
    drawGrid();
  }
  
  int getGridWidth()
  {
    return (gridSize * (boxWidth + gridPadding)) + gridPadding;
  }
  
  int getGridHeight()
  {
    return (gridSize * (boxHeight + gridPadding)) + gridPadding;
  }
  
  void drawGrid()
  {
    loadPixels();
    
    for (int gridX = 0; gridX < gridSize; gridX++)
    {
      for (int gridY = 0; gridY < gridSize; gridY++)
      {
        int x = gridX * (boxWidth + gridPadding) + gridPadding + offsetX;
        int y = gridY * (boxHeight + gridPadding) + gridPadding + offsetY;
        
        stroke(0);
        fill(200, 20);
        rect(x, y, boxWidth, boxHeight);
        
        int pixelIndex = ((y + gridPadding) * width) + x + gridPadding;
        float r = red(pixels[pixelIndex]);
        float g = green(pixels[pixelIndex]);
        float b = blue(pixels[pixelIndex]);
        
        if (gridX == 0 && gridY == 0)
        {
          //println(alpha(pixels[pixelIndex]) + ", " + r + ", " + g + ", " + b);
        }
        
        // Check the colour of the current box
        if (r == 192 && g == 204
          || (r == 204 && g == 192))
        {
          fill(192);
          rect(x, y, boxWidth, boxHeight);
        }
      }
    }
  }
  
  int getIndex(float x, float y)
  {
    x -= offsetX;
    y -= offsetY;
    if (x < 0 || x > getGridWidth() || y < 0 || y > getGridHeight()) return -1;
    
    int xIndex = int(map(x, 0, getGridWidth(), 1, 9));
    int yIndex = int(map(y, 0, getGridWidth(), 1, 9));
    
    return xIndex + ((yIndex - 1) * gridSize);
  }
  
  void lightBox(float x, float y)
  {
    lightBox(getIndex(x, y));
  }
  
  void lightBox(int index)
  {
    if (index == -1) return;
    float x = ((index - 1) % 8) * (boxWidth + gridPadding) + gridPadding + offsetX;
    float y = ((index - 1) / 8) * (boxHeight + gridPadding) + gridPadding + offsetY;
    
    stroke(0);
    fill(highlightColor);
    rect(x, y, boxWidth, boxHeight);
  }
  
  void lightBoxes(ArrayList indices)
  {
    if (indices == null) return;
    
    for (int i = 0; i < indices.size(); i++)
    {
      lightBox(((Integer) indices.get(i)));
    }
  }
}
