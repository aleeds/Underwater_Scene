
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

  void Draw(PVector pos) {
    // want this to be a texture mapped shape of some kind.
  }

  void UpdatePosition(PVector center,int rad) {
    // add stuff described in the comment at the top of the file
  }

  void VelocityUpdate() {
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

  void Draw() {
    for (Fish fish : fishes) fish.Draw(pos);
  }

  void UpdatePositionFish() {
    for (Fish fish : fishes) {
      fish.UpdatePosition(pos,rad);
    }
  }

  void UpdatePosition() {
    // update using the vel, change the vel
  }

  void Advance() {
    Draw();
    UpdatePositionFish();
    UpdatePosition();
  }
}