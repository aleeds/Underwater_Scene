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

PVector gerWaveNormal(PVector loc, float time, PVector[] direction, float[] amplitude, float[] wavelength, float[] speed, float sharpness[])
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float w = 2.0*PI/wavelength[i];
    float phi = speed[i]*w;
//    float q = 1/(w*amplitude[i]*(direction.length-sharpness[i]));
    float q = 0;
//    println("NORMAL        sin(D dot P * w + phi*loc.z) = " + sin(w*direction[i].dot(loc)+phi*loc.z));
    x += direction[i].x*w*amplitude[i]*cos(w*direction[i].x*loc.x+w*direction[i].y*loc.y+phi*time)/wavelength[i];
    y += direction[i].y*w*amplitude[i]*cos(w*direction[i].x*loc.x+w*direction[i].y*loc.y+phi*time)/wavelength[i];
    z += q*w*amplitude[i]*sin(w*direction[i].x*loc.x+w*direction[i].y*loc.y+phi*time);
  }
//  println("NORMAL:     x = " + x + ", y = " + y + ", z = " + z);
//  println("NORMAL:     loc = " + loc);
  PVector temp = new PVector(-x, -y, 1-z);
//  temp.normalize();
  return temp;
}

PVector gerWaveOther(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] speed, float sharpness[])
{
  float x = 0;
  float y = 0;
  float z = 0;
  for(int i = 0; i < direction.length; i++)
  {
    float w = 2*PI/wavelength[i];
    float phi = speed[i]*w;
//    float q = 1/(w*amplitude[i]*(direction.length-sharpness[i]));
    float q = 0;
    x += q*amplitude[i]*direction[i].x*cos(w*direction[i].x*x0+w*direction[i].y*y0+phi*t);
    y += q*amplitude[i]*direction[i].y*cos(w*direction[i].x*x0+w*direction[i].y*y0+phi*t);
    z += amplitude[i]*sin(w*direction[i].x*x0+w*direction[i].y*y0+phi*t);
  }
  return new PVector(x0 + x, y0 + y, z);
}
