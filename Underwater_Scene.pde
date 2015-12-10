import toxi.geom.Vec3D;

PShader shade;
PImage imgFloor;
QuadTree ocean;
GerWave[] waves;

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
  imgFloor = loadImage("OceanFloor.jpg");
  shade.set("textFloor", imgFloor);
  imageMode(CENTER);
  int k = 3;
  waves = new GerWave[k];
  for(int i = 0; i < k; i++)
  {
    PVector tmp = new PVector(map(randomGaussian(), -20.0, 20.0, -1.0, 1.0), map(randomGaussian(), -20.0, 20.0, -1.0, 1.0), 0.0);
    tmp.normalize();
    waves[i] = new GerWave(tmp, map(randomGaussian(), -50.0, 50.0, 0.0, 1.0)*50.0, map(randomGaussian(), -50.0, 50.0, 0.0, 1.0)*80.0, map(randomGaussian(), -50.0, 50.0, 0.0, 1.0)*40.0);
  }
  ocean = new QuadTree(new Coordinate(0, 0, 0), 8192.0, waves);
  

  dragged = rolled = false;
  prevAxis = new Vec3D(0,1,0);
}


void draw() {
  getCamera();
  shader(shade);
  background(111, 193, 237);
  pointLight(255, 255, 255, 500, 50000, 16000);
  fill(255);

  ocean.gerWaveDisplay();
  resetShader();
  
  dragged = false;
  rolled = false;
  translate(0,0,-1400);
  image(imgFloor, 0, 0, 16384, 16384);
 // noLoop();
}
