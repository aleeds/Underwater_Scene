
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
  float size;
  TextureSphere sphere;
  float angle;
  Fish(PVector pos_,PVector vel_,float size_,TextureSphere sp) {
    pos = pos_;
    vel = vel_;
    size = size_;
    sphere = sp;
    angle = random(0, 2 * PI);
  }

  void Draw(PVector center) {
    pushMatrix();
    translate(center.x,center.y ,center.z);
    translate(pos.x * cos(pos.y) * sin(pos.z),
              pos.x * sin(pos.y) * sin(pos.z),
              pos.x * cos(pos.z));
    rotateX(angle);
    sphere.display();
    popMatrix();
  }

  void UpdatePosition(PVector center,int rad) {
    pos.x += vel.x;
    if (pos.x > rad) {
      vel.x *= -1;
    }
    pos.y += vel.y;
    pos.z += vel.z;
  }

  void VelocityUpdate(float rad) {
    if (random(0,50) < 5) {
      PVector vel_change = new PVector(random(0,rad / 1000.0),
                                     random(-2 * PI / 400.0,2 * PI / 400.0),
                                     random(-PI / 400.0,PI / 400.0));
      vel.add(vel_change);
      angle = random(0, 2 * PI);
    }
  }


}

class Fish_Colony {
  ArrayList<Fish> fishes;
  PVector pos;
  PVector vel;
  int rad;
  Fish_Colony(PVector pos_,PVector vel_, int rad_, int num_fish,PImage img) {
    pos = pos_;
    vel = vel_;
    rad = rad_;
    fishes = new ArrayList<Fish>();
    TextureSphere sph = new TextureSphere(5,5,20,10,img);
    for (int i = 0;i < num_fish;++i) {
      PVector pos_fish = new PVector(random(0,rad),
                                     random(0,2 * PI),
                                     random(0,PI));
      PVector vec_fish = new PVector(random(0,rad / 100.0),
                                     random(-2 * PI / 100.0,2 * PI / 100.0),
                                     random(-PI / 100.0,PI / 100.0));
      sph.a = random(5,10);
      sph.c = random(15,25);
      fishes.add(new Fish(pos_fish,vec_fish,sph.a,sph));
    }
  }

  void Draw() {
    stroke(75);
    fill(135);
    sphereDetail(10);
    noStroke();
    for (Fish fish : fishes) fish.Draw(pos);
  }

  float distanceTo(PVector p,Vec3D vec) {
    float dx = p.x - vec.x;
    float dy = p.y - vec.y;
    float dz = p.z - vec.z;
    return sqrt(dx * dx + dy * dy + dz * dz);

  }

  void UpdatePositionFish() {
    for (Fish fish : fishes) {
      if (distanceTo(pos,cameraPos) > 1000) {
        fish.sphere.nSegs = 5;
      } else {
        fish.sphere.nSegs = 10;
      }
      fish.UpdatePosition(pos,rad);
      fish.VelocityUpdate(rad);
    }
  }

  void UpdatePosition() {

  }

  void Advance() {
    Draw();
    UpdatePositionFish();
    UpdatePosition();
  }
}


class TextureSphere {
  int nSegs;
  float a;
  float c;
  float t_s;
  PImage img;

  TextureSphere(float at, float ct,float t_st, int numSegs, PImage tex) {
   a = at;
   c = ct;
   t_s = t_st;
   nSegs = numSegs;
   img = tex;
  }

  float xpos(float u, float v) {
    return (t_s + a * cos(v)) * cos(u);
  }

  float ypos(float u, float v) {
    return (t_s + c * cos(v)) * sin(u);
  }

  float zpos(float u, float v) {
   return a * sin(v);
  }

  void createVertex(float u, float v) {
   float x = 2 * xpos(u,v);
   float y = ypos(u,v);
   float z = zpos(u,v);

   PVector norm = new PVector(x,y,z);
   norm.normalize();
   normal(norm.x,norm.y,norm.z);
   vertex(x,y,z,map(u,0,2 * PI,0,1),map(v,-PI, PI, 0,1));
  }

  void display() {
    beginShape(QUADS);
    texture(img);
    textureMode(NORMAL);
    float ustep = 2 * PI / nSegs;
    float vstep = PI / nSegs;
    for(float u = 0;u < 2 * PI; u += ustep) {
      for(float v = -PI;v < PI;v += vstep) {
        createVertex(u,v);
        createVertex(u + ustep,v);
        createVertex(u + ustep,v + vstep);
        createVertex(u,v + vstep);
      }
    }

    endShape();
  }
}
