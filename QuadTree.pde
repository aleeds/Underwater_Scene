class QuadTree
{
  Coordinate center;
  float sideLength, t, bounds;
  GerWave[] waves;
  QuadTree childNE, childNW, childSE, childSW;
  
  QuadTree(Coordinate _center, float _sideLength, GerWave[] _waves)
  {
    center = _center;
    sideLength = _sideLength;
    childNE = childNW = childSE = childSW = null;
    t=0;
    bounds = sideLength/2.0;
    waves = _waves;
  }
  
  QuadTree(Coordinate _center, float _sideLength, float _bounds)
  {
    center = _center;
    sideLength = _sideLength;
    childNE = childNW = childSE = childSW = null;
    t=0;
    bounds = _bounds;
  }
  
  QuadTree(Coordinate _center, float _sideLength, float _bounds, GerWave[] _waves)
  {
    center = _center;
    sideLength = _sideLength;
    childNE = childNW = childSE = childSW = null;
    t=0;
    bounds = _bounds;
    waves = _waves;
  }
  
  
  void setT(float _t)
  {
    t=_t;
  }
  
  void update()
  {
    t+=0.1f;
  }
  
  void subdivideNE()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x + sideLength/4.0, center.y - sideLength/4.0, center.z), sideLength/2.0, bounds, waves);
    childNE = child;
  }
  
  void subdivideNW()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x - sideLength/4.0, center.y - sideLength/4.0, center.z), sideLength/2.0, bounds, waves);
    childNW = child;
  }
  
  void subdivideSE()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x + sideLength/4.0, center.y + sideLength/4.0, center.z), sideLength/2.0, bounds, waves);
    childSE = child;
  }
  
  void subdivideSW()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x - sideLength/4.0, center.y + sideLength/4.0, center.z), sideLength/2.0, bounds, waves);
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
  
  
  void gerWaveDisplay()
  {
    if(childNE != null)
    {
      childNE.gerWaveDisplay();
      childNW.gerWaveDisplay();
      childSE.gerWaveDisplay();
      childSW.gerWaveDisplay();
    }
    else
    {
      //lots of declared variables here, but allows us to compute location and normal in one pass of the waves, so maybe good?
      update();
      float NWH = 0.0; //North-West z-component
      float NWNX = 0.0; //North-West normal x-component
      float NWNY = 0.0; //North-West normal y-component
      
      float NEH = 0.0;
      float NENX = 0.0;
      float NENY = 0.0;
      
      float SEH = 0.0;
      float SENX = 0.0;
      float SENY = 0.0;
      
      float SWH = 0.0;
      float SWNX = 0.0;
      float SWNY = 0.0;
      
      for(GerWave w : waves)
      {
        NWH += w.getHeight(center.x-sideLength/2.0, center.y-sideLength/2.0, t);
        NWNX -= w.getNormalX(center.x-sideLength/2.0, center.y-sideLength/2.0, t);
        NWNY -= w.getNormalY(center.x-sideLength/2.0, center.y-sideLength/2.0, t);
        
        NEH += w.getHeight(center.x+sideLength/2.0, center.y-sideLength/2.0, t);
        NENX -= w.getNormalX(center.x+sideLength/2.0, center.y-sideLength/2.0, t);
        NENY -= w.getNormalX(center.x+sideLength/2.0, center.y-sideLength/2.0, t);
        
        SEH += w.getHeight(center.x+sideLength/2.0, center.y+sideLength/2.0, t);
        SENX -= w.getNormalX(center.x+sideLength/2.0, center.y+sideLength/2.0, t);
        SENY -= w.getNormalX(center.x+sideLength/2.0, center.y+sideLength/2.0, t);
        
        SWH += w.getHeight(center.x-sideLength/2.0, center.y+sideLength/2.0, t);
        SWNX -= w.getNormalX(center.x-sideLength/2.0, center.y+sideLength/2.0, t);
        SWNY -= w.getNormalX(center.x-sideLength/2.0, center.y+sideLength/2.0, t);
      }
      
      PVector NW = new PVector(center.x-sideLength/2.0, center.y-sideLength/2.0, NWH);
      PVector NE = new PVector(center.x+sideLength/2.0, center.y-sideLength/2.0, NEH);
      PVector SE = new PVector(center.x+sideLength/2.0, center.y+sideLength/2.0, SEH);
      PVector SW = new PVector(center.x-sideLength/2.0, center.y+sideLength/2.0, SWH);
      
      PVector NWN = new PVector(NWNX, NWNY, 1);
      PVector NEN = new PVector(NENX, NENY, 1);
      PVector SEN = new PVector(SENX, SENY, 1);
      PVector SWN = new PVector(SWNX, SWNY, 1);
      
      beginShape();
      
      normal(NWN.x, NWN.y, NWN.z);
      vertex(NW.x, NW.y, NW.z);
      
      normal(NEN.x, NEN.y, NEN.z);
      vertex(NE.x, NE.y, NE.z);
      
      normal(SEN.x, SEN.y, SEN.z);
      vertex(SE.x, SE.y, SE.z);
      
      normal(SWN.x, SWN.y, SWN.z);
      vertex(SW.x, SW.y, SW.z);
      endShape();
      
    }
  }
}
