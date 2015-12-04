PVector gerWave(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] frequency)
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float k = 2*PI/wavelength[i];
    x += (direction[i].x/k)*amplitude[i]*sin(direction[i].x*x0-frequency[i]*t);
    y += (direction[i].y/k)*amplitude[i]*sin(direction[i].y*y0-frequency[i]*t);
    z += amplitude[i]*cos(direction[i].x*x0+direction[i].y*y0-frequency[i]*t);
  }
  return new PVector(x0 - x, y0 - y, z);
}

PVector gerWaveNormal(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] frequency)
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float k = 2*PI/wavelength[i];
    x += (direction[i].x/k)*amplitude[i]*sin(direction[i].x*x0-frequency[i]*t);
    y += (direction[i].y/k)*amplitude[i]*sin(direction[i].y*y0-frequency[i]*t);
    z += amplitude[i]*cos(direction[i].x*x0+direction[i].y*y0-frequency[i]*t);
  }
  return new PVector(x0 - x, y0 - y, z);
}