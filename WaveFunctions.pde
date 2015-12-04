PVector gerWave(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] frequency, float[] phase)
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float k = 2*PI/wavelength[i];
    x += (direction[i].x/k)*amplitude[i]*sin(direction[i].x*x0-frequency[i]*t+phase[i]);
    y += (direction[i].y/k)*amplitude[i]*sin(direction[i].y*y0-frequency[i]*t+phase[i]);
    z += amplitude[i]*cos(direction[i].x*x0+direction[i].y*y0-frequency[i]*t+phase[i]);
  }
  return new PVector(x0 - x, y0 - y, z);
}

PVector gerWaveNormal(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] frequency, float[] phase)
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float k = 2*PI/wavelength[i];
    x -= (direction[i].x/k)*amplitude[i]*sin(direction[i].x*x0-frequency[i]*t+phase[i]);
    y -= (direction[i].y/k)*amplitude[i]*sin(direction[i].y*y0-frequency[i]*t+phase[i]);
    z += amplitude[i]*cos(direction[i].x*x0+direction[i].y*y0-frequency[i]*t+phase[i]);
  }
  return new PVector(x, y, 1 - z);
}

PVector gerWaveOther(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] speed)
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float w = 2*PI/wavelength[i];
    float phi = speed[i]*w;
    x += amplitude[i]*direction[i].x*cos(w*direction[i].x*x0+w*direction[i].y*y0+phi*t);
    y += amplitude[i]*direction[i].y*cos(w*direction[i].x*x0+w*direction[i].y*y0+phi*t);
    z += amplitude[i]*sin(w*direction[i].x*x0+w*direction[i].y*y0+phi*t);
  }
  return new PVector(x0 + x, y0 + y, z);
}
