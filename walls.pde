//
void MakeWalls(ArrayList<PImage> textures) {
  pushMatrix();
  rectMode(RADIUS);
  rotateX(PI / 2);
  translate(cameraPos.x,cameraPos.y + 200,0);
  customRect(0,0,2000,2000,textures.get(0));
  popMatrix();
}

void customRect(PImage text,int x, int y, int xs, int ys) {
  beginShape(QUADS);
    vertex(x - xs, y - ys);
    vertex(x - xs, y + ys);
    vertex(x + xs, y + ys);
    vertex(x + xs, y - ys);
  endShape(FILL);
}
