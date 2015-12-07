import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.geom.Vec3D; 

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

float radius,angle;
boolean dragged, rolled;
Vec3D cameraPos, cameraUp, prevAxis;


public void setup()
{
  size(900,900,P3D);
  noStroke();
  radius = 300f;
  cameraPos = new Vec3D(0,0,radius);
  cameraUp = new Vec3D(0,-1,0);
//  shade = loadShader("waterFragment.glsl", "waterVertex.glsl");

  root = new QuadTree(new Coordinate(0, 0, 0), 8000.0f);

  for(int i=0; i<6; i++) root.subdivideAll();
  dragged = rolled = false;
  prevAxis = new Vec3D(0,1,0);
}


public void draw() {

  getCamera();
//  shader(shade);
  background(0);
  pointLight(255, 255, 255, 500, 500, 1000);
  fill(255);

  root.updateAndDisplay();
  dragged = false;
  rolled = false;
}
public void getCamera()
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
      float amt = map(pmouseX-mouseX,-30,30,-0.5f,0.5f);
      if(mouseY >= height/2.0f) amt = -amt; //needed?
      Vec3D tempAxis = cameraPos.copy().normalize();
      cameraUp.rotateAroundAxis(tempAxis,amt).normalize();
    }
    camera(cameraPos.x,cameraPos.y,cameraPos.z,0,0,0,cameraUp.x,cameraUp.y,cameraUp.z);
    perspective(PI/3.0f, width/height, cameraPos.magnitude()/10.0f, cameraPos.magnitude()*10000000.0f);
}

public void mouseWheel(MouseEvent event)
{
  float e = event.getCount();

  if(e > 0) cameraPos.scaleSelf(1.2f);
  else cameraPos.scaleSelf(0.8f);
}

public void mouseDragged()
{
  if(mouseButton == LEFT)
    dragged = true;
  else
    rolled = true;
}

public float[] axisMatrix(Vec3D axis)
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

public void rotateAboutAxis(PVector a, float amt)
{
  Vec3D w = new Vec3D(a.x, a.y, a.z);
  float[] m = axisMatrix(w);
  applyMatrix(m[0], m[1], m[2], 0,
              m[3], m[4], m[5], 0,
              m[6], m[7], m[8], 0,
              0.0f,  0.0f,  0.0f,  1);
  rotateZ(amt);
  applyMatrix(m[0], m[3], m[6], 0,
              m[1], m[4], m[7], 0,
              m[2], m[5], m[8], 0,
              0.0f,  0.0f,  0.0f,  1);
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
  FullSystem(LSystem systm, ArrayList<LRule> rul,String str) {
    lsystem = systm;
    rules = rul;
    start = str;
  }

  public void Draw(int i,int len) {
     String begin = start;
     for (int q = 0;q < i;++q) begin = FindRule(begin,rules).GetNext();
     DrawL(begin,lsystem,len);
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
