import toxi.geom.Vec3D;

PShader shade;
QuadTree root;
boolean sha;

float radius,angle;
boolean dragged, rolled;
Vec3D cameraPos, cameraUp, prevAxis;


void setup()
{
  size(900,900,P3D);
  noStroke();
  radius = 300f;
  cameraPos = new Vec3D(0,0,radius);
  cameraUp = new Vec3D(0,-1,0);
  shade = loadShader("waterFragment.glsl", "waterVertex.glsl");
  shade.set("lowBound", -300.0);
  shade.set("highBound", 300.0);
  PGraphicsOpenGL pgl = ((PGraphicsOpenGL) g);
//  println(pgl.modelviewInv);

  root = new QuadTree(new Coordinate(0, 0, 0), 2000.0);
//  root.subdivideAll();
  for(int i=0; i<6; i++) root.subdivideAll();
  dragged = rolled = false;
  prevAxis = new Vec3D(0,1,0);
}


void draw() {

  getCamera();
//  shade.set("t",t);
//  shade.set("modelviewInverse", ((PGraphicsOpenGL) g).modelviewInv);
//  shade.set("modelviewReal", ((PGraphicsOpenGL) g).modelview);
//  shade.set("projectionReal", ((PGraphicsOpenGL) g).projmodelview);
//  ((PGraphicsOpenGL) g).modelviewInv.print();
//  ((PGraphicsOpenGL) g).modelview.print();
//  ((PGraphicsOpenGL) g).projection.print();
//  shader(shade);
  background(0);
  stroke(255,0,0);
  line(0,0,0,100,0,0);
 // noStroke();
  pointLight(255, 255, 255, 500, 500, 600);
  fill(255);
  noStroke();

  root.updateAndDisplay();
  dragged = false;
  rolled = false;
}



