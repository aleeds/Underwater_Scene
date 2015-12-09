import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.geom.Vec3D; 
import toxi.geom.Matrix4x4; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Underwater_Scene extends PApplet {




PShader shade;
QuadTree root;
boolean sha;

float rotationAngle;
float elevationAngle;

float radius,angle;
boolean dragged, rolled;
Vec3D cameraPos, cameraUp,cameraDirection;

FullSystem lightning_bolt;

class LightningDraw extends LSystem {
  public void DrawChar(char c,int len) {
    if (c == '[') pushMatrix();
    else if (c == ']') popMatrix();
    else if (c == 'F') {
      if (random(0,50) < 3) {
        pointLight(255,255,255,0,len,len / 2);
      }
      line(0,0,0,0,len,len / 2);
      translate(0,len,len / 2);
    } else if (c == '+') rotateZ(PI / 12);
      else if (c == '-') rotateZ(-PI / 12);
      else if (c == 'Q') {
        rotateX(random(-PI / 32,PI / 32));
      }
  }
}



public void setup()
{
  size(900,900,P3D);
  noStroke();
  radius = 300f;
  //cameraPos = new Vec3D(0,0,radius);
  cameraPos = new Vec3D(width/2.0f, height/2.0f, (height/2.0f) / tan(PI*30.0f / 180.0f));
  printVec3D(cameraPos,"Camera Pos");
  cameraUp = new Vec3D(0,-1,0);
  cameraDirection = new Vec3D(0,0,-100);
  //rotationAngle = PI / 2.0;
  //elevationAngle = 0;
//  shade = loadShader("waterFragment.glsl", "waterVertex.glsl");
  lights();
  root = new QuadTree(new Coordinate(0, 0, 0), 8000.0f);

  for(int i=0; i<6; i++) root.subdivideAll();
  dragged = rolled = false;

  MakeLightningBolt();

}

public void MakeLightningBolt() {
  ArrayList<LRule> rules = new ArrayList<LRule>();
  String[] pos = {"QFF[+F][-F]","QFF[+FF]","QF[-F][+FF]",
                  "FFQ[+F]Q[-F]","FFQ[+FF]","F[-F][+FF]Q"};
  rules.add(new StochLRule("F",pos));
  lightning_bolt = new FullSystem(new LightningDraw(),rules, "F");
}

public void DrawLightningAtCoordinate(float x, float y, float z) {
  translate(x,y,z);
  //lightning_bolt.Draw(3,20);
  translate(-x,-y,-z);
}

boolean is_andy = true;

public void andy_draw() {
  background(0);
  getCamera();
  lights();
  fill(color(255,0,0));
  pushMatrix();
  translate(width / 2.0f,height / 2.0f,0);
  box(100);
  translate(200,0,0);
  sphere(100);
  translate(-200,0,0);
  translate(0,0,1200);
  sphere(100);
  translate(0,0,-1200);
  stroke(color(0,255,0));
  line(0,0,0,0,0,500);
  line(0,0,0,0,500,0);
  line(0,0,0,500,0,0);
  stroke(255);
  //DrawLightningAtCoordinate(100,0,50);

  translate(0,-100,-50);
  stroke(color(255,0,0));
  line(0,0,0,cameraUp.x * 100,cameraUp.y * 100,  cameraUp.z * 100);
  stroke(color(0,255,55));
  line(0,0,0,cameraDirection.x,cameraDirection.y,cameraDirection.z);
  popMatrix();
  keyPressedLocal();
}

public void draw() {
  if (is_andy) {
    andy_draw();
  } else {
  getCamera();
  //  shader(shade);
    background(0);
    pointLight(255, 255, 255, 500, 500, 1000);
    fill(255);

    root.updateAndDisplay();
    dragged = false;
    rolled = false;
  }
}
public void getCamera() {
  ModifyCamera();
  Vec3D cd = cameraPos.add(cameraDirection);
  camera(cameraPos.x, cameraPos.y,cameraPos.z,
         cd.x,cd.y,cd.z,
         cameraUp.x,cameraUp.y,cameraUp.z);
}


public void printVec3D(Vec3D vec,String name) {
  println(name + " " + vec.x + " " + vec.y + " " + vec.z + " ");
}
// this function will handle traditional video game first person controls.
public void ModifyCamera() {
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

public void MoveCamera() {
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

public void RotateCamera() {

}

public Vec3D RotateAroundAxis(Vec3D rotate,Vec3D axis, float theta) {
  Matrix4x4 r = axisMatrix(axis,theta);
  return r.applyTo(rotate.immutable());
}


// This lets the user move the camera by hitting the keys
// need to change to incorporate different camera directions.
public void keyPressedLocal() {
  if (keyPressed && key == CODED) {
    Vec3D right = cameraUp.cross(cameraDirection).scale(.2f);
    if (keyCode == UP) {
      cameraPos = cameraPos.add(cameraDirection.scale(.2f));
    }
    if (keyCode == DOWN) {
      cameraPos = cameraPos.sub(cameraDirection.scale(.2f));
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
public Matrix4x4 axisMatrix(Vec3D axis,float theta) {
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
class Coordinate
{
  float x,y,z;
  Coordinate(float _x, float _y, float _z)
  {
     x = _x;
     y = _y;
     z = _z;
  } 
}
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
    bounds = sideLength/2.0f;
  }
  
  QuadTree(Coordinate _center, float _sideLength, float _bounds)
  {
    center = _center;
    sideLength = _sideLength;
    childNE = childNW = childSE = childSW = null;
    t=0;
    bounds = _bounds;
  }
  
  public float heightFunction(float x, float y)
  {
    return (cos(map(x,-bounds,bounds,0,3.14159f)+t)*10.0f*sin(map(y,-bounds,bounds,0,3.14159f)+t));
  }
  
  public void setT(float _t)
  {
    t=_t;
  }
  
  public void update()
  {
    t+=0.01f;
  }
  
  public void subdivideNE()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x + sideLength/4.0f, center.y - sideLength/4.0f, center.z), sideLength/2.0f, bounds);
    childNE = child;
  }
  
  public void subdivideNW()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x - sideLength/4.0f, center.y - sideLength/4.0f, center.z), sideLength/2.0f, bounds);
    childNW = child;
  }
  
  public void subdivideSE()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x + sideLength/4.0f, center.y + sideLength/4.0f, center.z), sideLength/2.0f, bounds);
    childSE = child;
  }
  
  public void subdivideSW()
  {
    QuadTree child = new QuadTree(new Coordinate(center.x - sideLength/4.0f, center.y + sideLength/4.0f, center.z), sideLength/2.0f, bounds);
    childSW = child;
  }
  
  public void subdivide()
  {
    subdivideNE();
    subdivideNW();
    subdivideSE();
    subdivideSW();
  }
  
  public void subdivideAll() //used only to create more geometry
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
  
  public void subdivideNWOnly()
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
  
  public void display()
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
      float[] amplitude = {20.0f, 3.0f, 15.0f};
      float[] waveLength = {8.0f, 6.0f, 2.0f};
      float[] frequency = {3.0f, 1.0f, 5.0f};
      float[] phase = {1.0f, 0.57f};
      PVector NW = gerWave(center.x-sideLength/2.0f, center.y-sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector NE = gerWave(center.x+sideLength/2.0f, center.y-sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector SE = gerWave(center.x+sideLength/2.0f, center.y+sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector SW = gerWave(center.x-sideLength/2.0f, center.y+sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
//      PVector NWN = gerWaveNormal(center.x-sideLength/2.0, center.y-sideLength/2.0, t, waveDir, amplitude, waveLength, frequency);
      
      beginShape();
      vertex(center.x-sideLength/2.0f,center.y-sideLength/2.0f,heightFunction(center.x-sideLength/2.0f, center.y-sideLength/2.0f));
      vertex(center.x+sideLength/2.0f,center.y-sideLength/2.0f,heightFunction(center.x+sideLength/2.0f, center.y-sideLength/2.0f));
      vertex(center.x+sideLength/2.0f,center.y+sideLength/2.0f,heightFunction(center.x+sideLength/2.0f, center.y+sideLength/2.0f));
      vertex(center.x-sideLength/2.0f,center.y+sideLength/2.0f,heightFunction(center.x-sideLength/2.0f, center.y+sideLength/2.0f));
      endShape();
    }
  }
    
  public void updateAndDisplay()
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
      PVector[] waveDir = {new PVector(1,1,0), new PVector(-1,1,0), new PVector(0,1,0)};
      float[] amplitude = {20.0f, 3.0f, 15.0f};
      float[] waveLength = {8.0f, 6.0f, 2.0f};
      float[] frequency = {3.0f, 1.0f, 5.0f};
      float[] phase = {1.0f, 0.57f, 2.0f};
      PVector NW = gerWave(center.x-sideLength/2.0f, center.y-sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector NE = gerWave(center.x+sideLength/2.0f, center.y-sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector SE = gerWave(center.x+sideLength/2.0f, center.y+sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector SW = gerWave(center.x-sideLength/2.0f, center.y+sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      PVector NWN = gerWaveNormal(center.x-sideLength/2.0f, center.y-sideLength/2.0f, t, waveDir, amplitude, waveLength, frequency, phase);
      stroke(255,0,0);
      line(NW.x, NW.y, NW.z, NW.x+NWN.x, NW.y+NWN.y, NW.z+NWN.z);
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
public PVector gerWave(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] frequency, float[] phase)
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

public PVector gerWaveNormal(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] frequency, float[] phase)
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

public PVector gerWaveOther(float x0, float y0, float t, PVector[] direction, float[] amplitude, float[] wavelength, float[] speed)
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

// Will be a fish that lives in 3D, so pos will be a 3-vector
// they will however live inside a circle defined by the Fish_Colony that it
// lives in. This will mean that vel will also be a 3-vector, but interpreted
// differently.
// the vel will be interpreted as spherical coordinates
// the pos will also be spherical coordinates, and the drawing will happen with
// respect to the center of the sphere
// I will need to fiddle with the math.
class Fish {
  PVector pos;
  PVector vel;
  int size;
  Fish(PVector pos_,PVector vel_,int size_) {
    pos = pos_;
    vel = vel_;
    size = size_;
  }

  public void Draw(PVector pos) {
    // want this to be a texture mapped shape of some kind.
  }

  public void UpdatePosition(PVector center,int rad) {
    // add stuff described in the comment at the top of the file
  }

  public void VelocityUpdate() {
    // add random update stuff
  }
}

class Fish_Colony {
  ArrayList<Fish> fishes;
  PVector pos;
  PVector vel;
  int rad;
  Fish_Colony(PVector pos_,PVector vel_, int rad_, int num_fish) {
    pos = pos_;
    vel = vel_;
    rad = rad_;
    // make fish
  }

  public void Draw() {
    for (Fish fish : fishes) fish.Draw(pos);
  }

  public void UpdatePositionFish() {
    for (Fish fish : fishes) {
      fish.UpdatePosition(pos,rad);
    }
  }

  public void UpdatePosition() {
    // update using the vel, change the vel
  }

  public void Advance() {
    Draw();
    UpdatePositionFish();
    UpdatePosition();
  }
}
class LRule {
 String cur;
 String GoTo;

 public LRule() {}

 public String GetId() {
  return cur;
 }

 LRule(String c, String gt) {
   cur = c;
   GoTo = gt;
 }

 public String GetNext() {
   return GoTo;
 }

}

class StochLRule extends LRule {
 String cur;
 String[] GoTos;

 public String GetId() {
  return cur;
 }

 StochLRule(String c, String[] Gt) {
  cur = c;
  GoTos = Gt;
  println(cur);
 }

 public String GetNext() {
  return GoTos[(int)(random(0,GoTos.length))];
 }

}

class LSystem {
 public void DrawChar(char c,int len) {}
}


public LRule FindRule(String at, ArrayList<LRule> rules) {
  for (LRule rule : rules) {
    if (rule.GetId().equals(at)) return rule;
  }
  return (new LRule(at,at));
}

public String NextL(String cur, ArrayList<LRule> rules) {
  String ret = "";
  for (int j = 0;j < cur.length();++j) {
     char i = cur.charAt(j);
     String it = "" + i;
     LRule rule = FindRule(it,rules);
     ret += rule.GetNext();
  }
  return ret;
}

public void DrawL(String L, LSystem system,int len) {
 for (int j = 0;j < L.length();++j) {
   system.DrawChar(L.charAt(j),len);
 }
}

class FullSystem {
  LSystem lsystem;
  ArrayList<LRule> rules;
  String start;
  long seed;
  FullSystem(LSystem systm, ArrayList<LRule> rul,String str) {
    lsystem = systm;
    rules = rul;
    start = str;
  }

  public void Draw(int i,int len) {
     //randomSeed(seed);
     String begin = start;
     for (int q = 0;q < i;++q) begin = NextL(begin,rules);
     pushMatrix();
     DrawL(begin,lsystem,len);
     println(begin);
     popMatrix();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Underwater_Scene" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
