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
//  shade = loadShader("waterFragment.glsl", "waterVertex.glsl");

  root = new QuadTree(new Coordinate(0, 0, 0), 2000.0);

  for(int i=0; i<6; i++) root.subdivideAll();
  dragged = rolled = false;
  prevAxis = new Vec3D(0,1,0);
}


void draw() {

  getCamera();
//  shader(shade);
  background(0);
  stroke(255,0,0);
  line(0,0,0,100,0,0);
  pointLight(255, 255, 255, 500, 500, 600);
  fill(255);
  noStroke();

  root.updateAndDisplay();
  dragged = false;
  rolled = false;
}