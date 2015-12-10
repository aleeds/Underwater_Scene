//
void MakeWalls(ArrayList<PImage> textures) {
  pushMatrix();
  rectMode(RADIUS);
  rotateX(PI / 2);
  translate(cameraPos.x,cameraPos.y + 200,0);
  customRect(textures.get(0),0,0,2000,2000);
  popMatrix();
}

void customRect(PImage text,int x, int y, int xs, int ys) {
  beginShape(QUADS);
    vertex(x - xs, y - ys);
    vertex(x - xs, y + ys);
    vertex(x + xs, y + ys);
    vertex(x + xs, y - ys);
  endShape(CLOSE);
}

FullSystem MakeCoralWithPos(int x, int y, int z,int len) {
   FullSystem coral = MakeCoral();
   coral.seed = x * x * 29 + y * y * 3 - z * z * 7 - 53 * len;
   coral.pos = new PVector(x,y,z);
   return coral;
}

ArrayList<FullSystem> MakeManyCorals(ArrayList<PVector> poses,int[] len) {
  ArrayList<FullSystem> corals = new ArrayList<FullSystem>();
  for (int i = 0;i < poses.size();++i) {
    PVector pos = poses.get(i);
    corals.add(MakeCoralWithPos((int)pos.x,(int)pos.y,(int)pos.y,len[i]));

  }
  return corals;
}
