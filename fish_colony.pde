
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
  Fish(PVector pos_,PVector vel_,float size_) {
    pos = pos_;
    vel = vel_;
    size = size_;
  }

  void Draw(PVector center) {
    pushMatrix();
    translate(center.x,center.y ,center.z);
    translate(pos.x * cos(pos.y) * sin(pos.z),
              pos.x * sin(pos.y) * sin(pos.z),
              pos.x * cos(pos.z));
    sphere(size);
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
    }
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
    fishes = new ArrayList<Fish>();
    for (int i = 0;i < num_fish;++i) {
      PVector pos_fish = new PVector(random(0,rad),
                                     random(0,2 * PI),
                                     random(0,PI));
      PVector vec_fish = new PVector(random(0,rad / 100.0),
                                     random(-2 * PI / 100.0,2 * PI / 100.0),
                                     random(-PI / 100.0,PI / 100.0));
      fishes.add(new Fish(pos_fish,vec_fish,random(5,15)));
    }
  }

  void Draw() {
    stroke(75);
    fill(135);
    sphereDetail(10);
    for (Fish fish : fishes) fish.Draw(pos);
  }

  void UpdatePositionFish() {
    for (Fish fish : fishes) {
      fish.UpdatePosition(pos,rad);
      fish.VelocityUpdate(rad);
    }
  }

  void UpdatePosition() {
    pos.add(vel);
    if (random(0,50) < 1) {
      vel = new PVector(random(-10,10),random(-1,1),random(-10,10));
    } else if (random(0,50) < 5) {
      vel.add(new PVector(random(-5,5),random(-.1,.1),random(-1,1)));
    }
  }

  void Advance() {
    Draw();
    UpdatePositionFish();
    UpdatePosition();
  }
}
