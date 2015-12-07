class QuadTree
{
  Coordinate center;
  float sideLength, t, bounds;
  QuadTree childNE, childNW, childSE, childSW;
  
  QuadTree(Coordinate _center, float _sideLength)
  {
    center = _center;
    sideLength = _sideLength;
    childNE = childNW = childSE = childSW = null;
    t=0;
    bounds = sideLength/2.0;
  }
  
  QuadTree(Coordinate _center, float _sideLength, float _bounds)
  {
    center = _center;
    sideLength = _sideLength;
    childNE = childNW = childSE = childSW = null;
    t=0;
    bounds = _bounds;
  }
  
  float heightFunction(float x, float y)
  {
    return (cos(map(x,-bounds,bounds,0,3.14159)+t)*10.0*sin(map(y,-bounds,bounds,0,3.14159)+t));
  }
  
  void setT(float _t)
  {
    t=_t;
  }
  
  void update()
  {
    t+=0.01f;
  }
  
  void subdivideNE()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x + sideLength/4.0, center.y - sideLength/4.0, center.z), sideLength/2.0, bounds);
    childNE = child;
  }
  
  void subdivideNW()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x - sideLength/4.0, center.y - sideLength/4.0, center.z), sideLength/2.0, bounds);
    childNW = child;
  }
  
  void subdivideSE()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x + sideLength/4.0, center.y + sideLength/4.0, center.z), sideLength/2.0, bounds);
    childSE = child;
  }
  
  void subdivideSW()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x - sideLength/4.0, center.y + sideLength/4.0, center.z), sideLength/2.0, bounds);
    childSW = child;
  }
  
  void subdivide()
  {
    subdivideNE();
    subdivideNW();
    subdivideSE();
    subdivideSW();
  }
  
  void subdivideAll() //used only to create more geometry
  {
    if(childNE != null)
    {
      childNE.subdivideAll();
      childNW.subdivideAll();
      childSE.subdivideAll();
      childSW.subdivideAll();
    }
    else
    {
      subdivide();
    }
  }
  
  void subdivideNWOnly()
  {
    if(childNW != null)
    {
      childNW.subdivideNWOnly();
    }
    else
    {
      subdivide();
    }
  }
  
  void display()
  {
    if(childNE != null)
    {
      childNE.display();
      childNW.display();
      childSE.display();
      childSW.display();
    }
    else
    {
      PVector[] waveDir = {new PVector(1,1,0), new PVector(-1,1,0), new PVector(0,1,0)};
      float[] amplitude = {20.0, 3.0, 15.0};
      float[] waveLength = {8.0, 6.0, 2.0};
      float[] frequency = {3.0, 1.0, 5.0};
      float[] phase = {1.0, 0.57};
      PVector NW = gerWave(center.x-sideLength/2.0, center.y-sideLength/2.0, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector NE = gerWave(center.x+sideLength/2.0, center.y-sideLength/2.0, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector SE = gerWave(center.x+sideLength/2.0, center.y+sideLength/2.0, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector SW = gerWave(center.x-sideLength/2.0, center.y+sideLength/2.0, t, waveDir, amplitude, waveLength, frequency, phase);
//      PVector NWN = gerWaveNormal(center.x-sideLength/2.0, center.y-sideLength/2.0, t, waveDir, amplitude, waveLength, frequency);
      
      beginShape();
      vertex(center.x-sideLength/2.0,center.y-sideLength/2.0,heightFunction(center.x-sideLength/2.0, center.y-sideLength/2.0));
      vertex(center.x+sideLength/2.0,center.y-sideLength/2.0,heightFunction(center.x+sideLength/2.0, center.y-sideLength/2.0));
      vertex(center.x+sideLength/2.0,center.y+sideLength/2.0,heightFunction(center.x+sideLength/2.0, center.y+sideLength/2.0));
      vertex(center.x-sideLength/2.0,center.y+sideLength/2.0,heightFunction(center.x-sideLength/2.0, center.y+sideLength/2.0));
      endShape();
    }
  }
    
  void updateAndDisplay()
  {
    if(childNE != null)
    {
      childNE.updateAndDisplay();
      childNW.updateAndDisplay();
      childSE.updateAndDisplay();
      childSW.updateAndDisplay();
    }
    else
    {
      update();
//      PVector[] waveDir = {new PVector(1,1,0), new PVector(-1,1,0), new PVector(0,1,0)};
//      float[] amplitude = {20.0, 3.0, 15.0};
//      float[] waveLength = {8.0, 6.0, 2.0};
//      float[] speed = {3.0, 1.0, 5.0};
//      float[] phase = {1.0, 0.57, 2.0};

      PVector[] waveDir = {new PVector(1,0,0)};
      float[] amplitude = {80.0};
      float[] waveLength = {30.0};
      float[] speed = {6.0};
      float[] sharpness = {0.85}; //value theoretically between 0 (no pointyness) and 1 (really pointy) but actually higher than ~ 0.96 creates weird results as basically dividing by 0, and lower than ~ 0.8 doesnt really do much, so may end up mapping

      PVector NW = gerWaveOther(center.x-sideLength/2.0, center.y-sideLength/2.0, t, waveDir, amplitude, waveLength, speed, sharpness);
      PVector NE = gerWaveOther(center.x+sideLength/2.0, center.y-sideLength/2.0, t, waveDir, amplitude, waveLength, speed, sharpness);
      PVector SE = gerWaveOther(center.x+sideLength/2.0, center.y+sideLength/2.0, t, waveDir, amplitude, waveLength, speed, sharpness);
      PVector SW = gerWaveOther(center.x-sideLength/2.0, center.y+sideLength/2.0, t, waveDir, amplitude, waveLength, speed, sharpness);
      PVector NWN = gerWaveNormal(NW, t, waveDir, amplitude, waveLength, speed, sharpness);
      stroke(255,0,0);
      line(NW.x, NW.y, NW.z, NW.x+NWN.x*100, NW.y+NWN.y*100, NW.z+NWN.z);
      noStroke();
      
      beginShape();
      vertex(NW.x, NW.y, NW.z);
      vertex(NE.x, NE.y, NE.z);
      vertex(SE.x, SE.y, SE.z);
      vertex(SW.x, SW.y, SW.z);
      endShape();
    }
  }
}
