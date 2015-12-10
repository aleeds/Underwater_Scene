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

void JankyHackCamera(float dx,float dy) {
  Vec3D right = cameraUp.cross(cameraDirection);
  right.normalize();
  //cameraUp = RotateAroundAxis(cameraUp,right,dy);
  //cameraDirection = RotateAroundAxis(cameraDirection,right,dy);
  cameraUp.normalize();
  cameraDirection = RotateAroundAxis(cameraDirection,cameraUp,dx);
  cameraDirection.normalize();

  cameraDirection = RotateAroundAxis(cameraDirection,right,dy);
  cameraDirection.normalize();
  cameraUp.normalize();
  right.normalize();
  //cameraUp = RotateAroundAxis(cameraUp,right,dy);
  cameraUp.normalize();
  cameraDirection = cameraDirection.scale(100);
}



void MoveCamera() {
   float dx = mouseX - pmouseX;
   float dy = mouseY - pmouseY;
   float num_hacks = 100.0;
   float amtx_max = dx * PI / 256;
   float amtx = amtx_max / num_hacks;
   float amty_max = dy * PI / 256;
   float amty = amty_max / num_hacks;
   Vec3D right = cameraUp.cross(cameraDirection);
   for (float i = 0;i < num_hacks;i += 1) {
     JankyHackCamera(amtx,amty);
   }
}

Vec3D RotateCameraAngle(Vec3D tmp,float theta) {
  cameraDirection.normalize();
  tmp = RotateAroundAxis(tmp,cameraDirection,theta);
  cameraDirection = cameraDirection.scale(100);
  tmp.normalize();
  return tmp;
}

void RotateCamera() {
   PVector first = new PVector(mouseX, mouseY);
   first.normalize();
   PVector second = new PVector(pmouseX, pmouseY);
   second.normalize();
   float ang_one = acos(first.dot(new PVector(1,0)));
   float ang_two = acos(second.dot(new PVector(1,0)));
   cameraUp = RotateCameraAngle(cameraUp,ang_one - ang_two);
}

Vec3D RotateAroundAxis(Vec3D rotate,Vec3D axis, float theta) {
   Matrix4x4 r = axisMatrix(axis,theta);
   return r.applyTo(rotate.immutable());

}


// This lets the user move the camera by hitting the keys
// need to change to incorporate different camera directions.
void keyPressedLocal() {
  if (keyPressed) {
    Vec3D right = cameraUp.cross(cameraDirection).scale(.2);
    if ((key == CODED && keyCode == UP) || key == 'w') {
      cameraPos = cameraPos.add(cameraDirection.scale(.2));
    }
    if ((key == CODED && keyCode == DOWN) || key == 's') {
      cameraPos = cameraPos.sub(cameraDirection.scale(.2));
    }
    if ((key == CODED && keyCode == LEFT) || key == 'a') {
      cameraPos = cameraPos.add(right);
    }
    if ((key == CODED && keyCode == RIGHT) || key == 'd') {
      cameraPos = cameraPos.sub(right);
    }
  }
}


// This comes from a StackoverFlow post.
// http://stackoverflow.com/questions/22745937/understanding-the-math-behind-rotating-around-an-arbitrary-axis-in-webgl
// Confirmed by Wikipedia Page: Quaternion and Spacial Rotation
Matrix4x4 axisMatrix(Vec3D axis,float theta) {
   axis.normalize();
   double x = axis.x;
   double y = axis.y;
   double z = axis.z;
   double c = cos(theta);
   double s = sin(theta);
   double nc = 1 - c;

   double[] e = {c+ x*x*nc, x*y* nc - z*s, x*z*nc + y*s,0,
                 y*x*nc + z* s, c + y*y*nc, y*z*nc - x*s,0,
                 z*x*nc - y*s, z*y*nc + x*s, c + z*z*nc,0,
                 0,0,0,1};

   return new Matrix4x4(e);

}
