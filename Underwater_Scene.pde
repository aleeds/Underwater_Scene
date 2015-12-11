import toxi.geom.Vec3D;
import toxi.geom.Matrix4x4;

PShader shade;
PImage imgFloor;
QuadTree ocean;
GerWave[] waves;

float rotationAngle;
float elevationAngle;

float radius,angle;
boolean dragged, rolled;
Vec3D cameraPos, cameraUp,cameraDirection;

float angle_off = 0;
Vec3D absolute_up = new Vec3D(0,-1,0);

FullSystem lightning_bolt;

class LightningDraw extends LSystem {
  void DrawChar(char c,int len) {
    if (c == '[') pushMatrix();
    else if (c == ']') popMatrix();
    else if (c == 'F') {
      float factor = random(.5,3);
      if (random(0,50) < 3) {
        pointLight(255,255,255,0,-len,len / factor);
      }
      line(0,0,0,0,-len,len / factor);
      translate(0,-len,len / factor);
    } else if (c == '+') rotateZ(PI / 12);
      else if (c == '-') rotateZ(-PI / 12);
      else if (c == 'Q') {
        rotateX(random(-PI / 32,PI / 32));
      }
  }
}

Fish_Colony colony;
ArrayList<FullSystem> corals;
void andy_setup() {
  size(900,900,P3D);
  cameraPos = new Vec3D(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
//  printVec3D(cameraPos,"Camera Pos");
  cameraUp = new Vec3D(0,1,0);
  cameraDirection = new Vec3D(0,0,-100);
  dragged = rolled = false;
  PImage img = loadImage("fish.jpg");
  colony = new Fish_Colony(new PVector(0,0,0),new PVector(10,-1,2),100,20,img);
  //MakeLightningBolt();
  ArrayList<PVector> pos_corals = new ArrayList<PVector>();
  pos_corals.add(new PVector(100,0,75));
  pos_corals.add(new PVector(200,0,300));
  pos_corals.add(new PVector(-160,0,430));
  pos_corals.add(new PVector(1000,0,600));
  pos_corals.add(new PVector(-100,0,-1000));
  int[] len = {5,6,4,7,9};
  corals = MakeManyCorals(pos_corals,len);
}

void setup() {
  if (is_andy) {
    andy_setup();
  } else {
    size(900,900,P3D);
    noStroke();
    radius = 300f;
    cameraPos = new Vec3D(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
    cameraUp = new Vec3D(0,-1,0);
    cameraDirection = new Vec3D(0,0,-100);
    lights();
    shade = loadShader("pixlitfrag.glsl", "pixlitvert.glsl");
    imgFloor = loadImage("OceanFloor.jpg");
    shade.set("textFloor", imgFloor);
    imageMode(CENTER);
    int k = 1;
    waves = new GerWave[k];
    for(int i = 0; i < k; i++)
    {
      PVector tmp = new PVector(map(randomGaussian(), -20.0, 20.0, -1.0, 1.0), map(randomGaussian(), -20.0, 20.0, -1.0, 1.0), 0.0);
      tmp.normalize();
      waves[i] = new GerWave(tmp, map(randomGaussian(), -50.0, 50.0, 0.0, 1.0)*50.0, map(randomGaussian(), -50.0, 50.0, 0.0, 1.0)*80.0, map(randomGaussian(), -50.0, 50.0, 0.0, 1.0)*40.0);
    }
    ocean = new QuadTree(new Coordinate(0, 0, 0), 8192.0, waves);


    for(int i=0; i<6; i++) ocean.subdivideAll();
    dragged = rolled = false;
  }
}

// void MakeLightningBolt() {
//   ArrayList<LRule> rules = new ArrayList<LRule>();
//   String[] pos = {"QFF[+F][-F]","QFF[+FF]","QF[-F][+FF]",
//                   "FFQ[+F]Q[-F]","FFQ[+FF]","F[-F][+FF]Q"};
//   rules.add(new StochLRule("F",pos));
//   lightning_bolt = new FullSystem(new LightningDraw(),rules, "F");
// }
//
// void DrawLightningAtCoordinate(float x, float y, float z) {
//   translate(x,y,z);
//   lightning_bolt.Draw(2,(int)(y / 2));
//   translate(-x,-y,-z);
// }

boolean is_andy = false;

void andy_draw() {
  background(color(15,84,107));
  getCamera();
  lights();
  fill(color(255,0,0));
  pushMatrix();
  //MakeWalls();
  translate(width / 2.0,height / 2.0,0);
  shade = loadShader("pixlitfrag.glsl", "pixlitvert.glsl");
  shade.set("textFloor", imgFloor);
  imgFloor = loadImage("OceanFloor.jpg");
  pushMatrix();
  rotateX(PI / 2);
  translate(0,0,-1400);

  image(imgFloor, 0, 0, 16384, 16384);
  popMatrix();
  imageMode(CENTER);
  pushMatrix();
  for (FullSystem coral : corals) coral.Draw(3,5);
  colony.Advance();
  popMatrix();

  popMatrix();
  stroke(255);
  keyPressedLocal();
}

void draw() {
  if (is_andy) {
    andy_draw();
  } else {
    getCamera();
    shader(shade);
    background(0);
    pointLight(255, 255, 255, 500, 500, 1000);
    fill(255);
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
  }

}