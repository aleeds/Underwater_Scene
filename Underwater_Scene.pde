import toxi.geom.Vec3D;
import toxi.geom.Matrix4x4;

PShader shade, underWater;
PImage imgFloor, imgCeil;
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
ArrayList<FullSystem> rocks;
void andy_setup() {
  size(900,900,P3D);
  cameraPos = new Vec3D(625, -307, -539);
  cameraUp = new Vec3D(0,0,-1);
  cameraDirection = new Vec3D(-33,91,-23);
  dragged = rolled = false;
  PImage img = loadImage("fish.jpg");
  colony = new Fish_Colony(new PVector(435,567,-751),new PVector(0,0,0),400,20,img);
  //MakeLightningBolt();
  ArrayList<PVector> pos_corals = new ArrayList<PVector>();
  //pos_corals.add(new PVector(100,800,75));
  pos_corals.add(new PVector(200,800,300));
  pos_corals.add(new PVector(-160,800,430));
  //pos_corals.add(new PVector(1000,800,600));
  pos_corals.add(new PVector(-100,800,-1000));
  int[] len = {6,4,9};
  corals = MakeManyCorals(pos_corals,len);
  rocks = MakeManyRocks(pos_corals,len);
  noStroke();
  lights();
  shade = loadShader("pixlitfrag.glsl", "pixlitvert.glsl");
  underWater = loadShader("underwaterfrag.glsl");
  imgFloor = loadImage("OceanFloor.jpg");
  imgCeil = loadImage("Sky.jpg");
  shade.set("textFloor", imgFloor);
  shade.set("zSign", -1.0);
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
}

void setup() {
  size(900,900,P3D);
  cameraPos = new Vec3D(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
  cameraUp = new Vec3D(0,1,0);
  cameraDirection = new Vec3D(0,0,-100);
  dragged = rolled = false;
  if (is_andy) {
    andy_setup();
  } else {

    noStroke();
    lights();
    shade = loadShader("pixlitfrag.glsl", "pixlitvert.glsl");
    underWater = loadShader("underwaterfrag.glsl");
    imgFloor = loadImage("OceanFloor.jpg");
    imgCeil = loadImage("Sky.jpg");
    shade.set("textFloor", imgFloor);
    shade.set("zSign", -1.0);
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

boolean is_andy = true;

void andy_draw() {
  printVec3D(cameraPos,"Position");
  printVec3D(cameraDirection,"Direction");
  background(color(111,193,237));
  getCamera();
  lights();
 // fill(color(255,0,0)); this is why everything was red
  pushMatrix();
  //MakeWalls();
  translate(width / 2.0,height / 2.0,0);
  imageMode(CENTER);
  pushMatrix();
  rotateX(-PI / 2);
  translate(0,0,-1400);
  // I drew this
  pushMatrix();
  translate(0,1000,0);
  rotateX(PI / 2);
 // colorMode(RGB);
  image(imgFloor, 0, 0, 16384, 16384);
  popMatrix();
  popMatrix();

 if(cameraPos.z <= 0)
  {
//    image(imgCeil, 0, 0, 16384, 16384);
    shade.set("textFloor", imgCeil);
    shade.set("zSign", 1.0);
  }
  else
  {
    shade.set("textFloor", imgFloor);
    shade.set("zSign", -1.0);
  }
  shader(shade);
  noStroke();
  ocean.gerWaveDisplay();
  if(cameraPos.z <= 0)
  {
//    colorMode(RGB);
    //tint(190, 255, 255);
    //tint(100, 200, 200);
    //filter(underWater);
  }
  else
  {
    noTint();
  }
  // I drew this, from this line
  resetShader();
  imageMode(CENTER);
  pushMatrix();
  for (FullSystem coral : corals) {
    pushMatrix();
    translate(0,-500,0);
    rotateX(-PI / 2);
    translate(0,-150,0);
    coral.Draw(4,15);
    popMatrix();
  }
  for (FullSystem rock : rocks) {
    pushMatrix();
    translate(0,-500,0);
    rotateX(-PI / 2);
    translate(0,-150,0);
    rock.Draw(3,15);
    popMatrix();
  }

  colony.Advance();

  // to this line
  popMatrix();

  popMatrix();
  noStroke();

  stroke(255);
  keyPressedLocal();
}

void draw() {
  if (is_andy) {
    andy_draw();
  } else {
    getCamera();
    resetShader();

    if(cameraPos.z <= 0)
    {
      image(imgCeil, 0, 0, 16384, 16384);
      shade.set("textFloor", imgCeil);
      shade.set("zSign", 1.0);
    }
    else
    {
      shade.set("textFloor", imgFloor);
      shade.set("zSign", -1.0);
    }
    shader(shade);
    background(111, 193, 237);
    pointLight(255, 255, 255, 500, 50000, 16000);
    fill(255);

    ocean.gerWaveDisplay();
    resetShader();
    keyPressedLocal();
    dragged = false;
    rolled = false;
    translate(0,0,-1400);
    image(imgFloor, 0, 0, 16384, 16384);
    translate(0,0,1400);
    if(cameraPos.z <= 0)
    {
      tint(190, 255, 255);
      //filter(underWater);
    }
    else
    {
      noTint();
    }
  }

}
