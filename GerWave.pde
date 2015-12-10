class GerWave
{
  PVector direction;
  float amplitude;
  float waveLength;
  float frequency;
  float w;
  float phi;
  float q;
  
  GerWave(PVector _direction, float _amplitude, float _waveLength, float _frequency)
  {
    direction = _direction;
    amplitude = _amplitude;
    waveLength = _waveLength;
    frequency = sqrt(9.8*direction.mag());
    w = 2.0*PI/waveLength;
    phi = frequency * w;
    q = 0; //may be changed
  }
  
  float getHeight(float x0, float y0, float t) //since q is 0, we can take some shortcuts
  {
    return amplitude*sin(w*direction.x*x0+w*direction.y*y0+phi*t) + noise(x0, y0)*20.0;
  }
  
  float getNormalX(float x0, float y0, float t) // again cheaty cause q = 0
  {
    return direction.x*w*amplitude*cos(w*direction.x*x0+w*direction.y*y0+phi*t)/waveLength;
  }
  
  float getNormalY(float x0, float y0, float t)
  {
    return direction.y*w*amplitude*cos(w*direction.x*x0+w*direction.y*y0+phi*t)/waveLength;
  }
  
}

