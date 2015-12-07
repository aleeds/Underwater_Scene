void getCamera()
{
    float epsilon = 0.5f;
    Vec3D cameraRight = cameraUp.cross(cameraPos).normalize();

    if(dragged)
    {
      prevAxis = cameraRight.scale(mouseX-pmouseX).add(cameraUp.scale(mouseY-pmouseY));
    }



    if(dragged)
    {
      Vec3D tempAxis = prevAxis.cross(cameraPos).normalize();
      cameraUp.rotateAroundAxis(tempAxis,map(prevAxis.magnitude(),0,150,0,1)).normalize();
      cameraPos.rotateAroundAxis(tempAxis,map(prevAxis.magnitude(),0,150,0,1));
    }
    else if(rolled)
    {
      float amt = map(pmouseX-mouseX,-30,30,-0.5,0.5);
      if(mouseY >= height/2.0) amt = -amt; //needed?
      Vec3D tempAxis = cameraPos.copy().normalize();
      cameraUp.rotateAroundAxis(tempAxis,amt).normalize();
    }
    camera(cameraPos.x,cameraPos.y,cameraPos.z,0,0,0,cameraUp.x,cameraUp.y,cameraUp.z);
    perspective(PI/3.0, width/height, cameraPos.magnitude()/10.0, cameraPos.magnitude()*10000000.0);
}

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();

  if(e > 0) cameraPos.scaleSelf(1.2);
  else cameraPos.scaleSelf(0.8);
}

void mouseDragged()
{
  if(mouseButton == LEFT)
    dragged = true;
  else
    rolled = true;
}

float[] axisMatrix(Vec3D axis)
{
    Vec3D w = axis.copy();
    w.normalize();
    Vec3D t = w.copy();
    if (w.x == min(w.x, w.y, w.z)) {
      t.x = 1;
    }
    else if (w.y == min(w.x, w.y, w.z)) {
      t.y = 1;
    }
    else if (w.z == min(w.x, w.y, w.z)) {
      t.z = 1;
    }
    Vec3D u = w.cross(t);
    u.normalize();
    Vec3D v = w.cross(u);
    v.normalize();
    return new float[]{u.x, v.x, w.x,
                       u.y, v.y, w.y,
                       u.z, v.z, w.z};
}

void rotateAboutAxis(PVector a, float amt)
{
  Vec3D w = new Vec3D(a.x, a.y, a.z);
  float[] m = axisMatrix(w);
  applyMatrix(m[0], m[1], m[2], 0,
              m[3], m[4], m[5], 0,
              m[6], m[7], m[8], 0,
              0.0,  0.0,  0.0,  1);
  rotateZ(amt);
  applyMatrix(m[0], m[3], m[6], 0,
              m[1], m[4], m[7], 0,
              m[2], m[5], m[8], 0,
              0.0,  0.0,  0.0,  1);
}
