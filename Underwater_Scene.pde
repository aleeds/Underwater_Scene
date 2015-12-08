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
  shade = loadShader("pixlitfrag.glsl", "pixlitvert.glsl");

  root = new QuadTree(new Coordinate(0, 0, 0), 8192.0);

  for(int i=0; i<6; i++) root.subdivideAll();
  dragged = rolled = false;
  prevAxis = new Vec3D(0,1,0);
}


void draw() {

  getCamera();
  shader(shade);
  background(111, 193, 237);
  pointLight(255, 255, 255, 500, 50000, 16000);
  fill(255);

  root.updateAndDisplay();
  dragged = false;
  rolled = false;
 // noLoop();
}
