void getCamera() {
  ModifyCamera();
  Vec3D cd = cameraPos.add(cameraDirection);
  camera(cameraPos.x, cameraPos.y,cameraPos.z,
         cd.x,cd.y,cd.z,
         cameraUp.x,cameraUp.y,cameraUp.z);
}


void printVec3D(Vec3D vec,String name) {
  println(name + " " + vec.x + " " + vec.y + " " + vec.z + " ");
}
// this function will handle traditional video game first person controls.
void ModifyCamera() {
   float dx = mouseX - pmouseX;
   float dy = mouseY - pmouseY;
   if (dx != 0 || dy != 0) {
      if (mouseButton == RIGHT) {
        RotateCamera();
      } else if (mouseButton == LEFT) {
        MoveCamera();
      }
   }
}

void MoveCamera() {
  float dx = mouseX - pmouseX;
  float dy = mouseY - pmouseY;
  if (dy != 0) {
    cameraDirection.normalize();
    Vec3D right = cameraUp.cross(cameraDirection);
    right.normalize();
    cameraDirection = RotateAroundAxis(cameraDirection,right,-dy * PI / 128);
    cameraDirection.normalize();
    cameraDirection = cameraDirection.scale(100);
    cameraUp = RotateAroundAxis(cameraUp,right,-dy * PI / 128);
    cameraUp.normalize();
    println(cameraUp.dot(cameraDirection));
  }
  if (dx != 0) {
    cameraUp.normalize();
    cameraDirection = RotateAroundAxis(cameraDirection,cameraUp,dx * PI / 256);
    cameraDirection.normalize();
    cameraDirection = cameraDirection.scale(100);
  }


}

void RotateCamera() {

}

Vec3D RotateAroundAxis(Vec3D rotate,Vec3D axis, float theta) {
  Matrix4x4 r = axisMatrix(axis,theta);
  return r.applyTo(rotate.immutable());
}


// This lets the user move the camera by hitting the keys
// need to change to incorporate different camera directions.
void keyPressedLocal() {
  if (keyPressed && key == CODED) {
    Vec3D right = cameraUp.cross(cameraDirection).scale(.2);
    if (keyCode == UP) {
      cameraPos = cameraPos.add(cameraDirection.scale(.2));
    }
    if (keyCode == DOWN) {
      cameraPos = cameraPos.sub(cameraDirection.scale(.2));
    }
    if (keyCode == LEFT) {
      cameraPos = cameraPos.add(right);
    }
    if (keyCode == RIGHT) {
      cameraPos = cameraPos.sub(right);
      saveFrame("picture_for_hibbs.png");
    }
  }
}


// This comes from a StackoverFlow post.
// http://stackoverflow.com/questions/22745937/understanding-the-math-behind-rotating-around-an-arbitrary-axis-in-webgl
Matrix4x4 axisMatrix(Vec3D axis,float theta) {
   axis.normalize();
   double c = cos(theta);
   double s = sin(theta);
   double nc = 1 - c;
   double xy = axis.x * axis.y;
   double yz = axis.y * axis.z;
   double zx = axis.z * axis.x;
   double xs = axis.x * s;
   double ys = axis.y * s;
   double zs = axis.z * s;
   double[] e = {0,0,0,0,
                 0,0,0,0,
                 0,0,0,0,
                 0,0,0,0};
   e[ 0] = axis.x*axis.x*nc +  c;
   e[ 1] = xy *nc + zs;
   e[ 2] = zx *nc - ys;
   e[ 3] = 0;

   e[ 4] = xy *nc - zs;
   e[ 5] = axis.y*axis.y*nc +  c;
   e[ 6] = yz *nc + xs;
   e[ 7] = 0;

   e[ 8] = zx *nc + ys;
   e[ 9] = yz *nc - xs;
   e[10] = axis.z*axis.z*nc +  c;
   e[11] = 0;

   e[12] = 0;
   e[13] = 0;
   e[14] = 0;
   e[15] = 1;
   return new Matrix4x4(e);

}
