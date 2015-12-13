
class Boat {
  int size;
  Boat(int sz) {
    size = sz;
  }
  void Draw() {
    int w = size * 2;
    int l = size;
    int h = size * 3;
    DrawRectangle(w,l, h);
    DrawPyramid(new PVector(w / 2, -l / 2, h / 4),
                new PVector(-w / 2, -l / 2, h / 4),
                new PVector(0, l / 2,h / 4),
                new PVector(0,- l,3 * h / 4));
    pushMatrix();
    translate(0,-h / 2, 0);
    DrawRectangle(size / 4, size * 3, size / 4);
    popMatrix();
  }

  void DrawTestPyramid() {
    DrawPyramid(new PVector(100,100,100),new PVector(0,100,100),
                new PVector(0,0,100),new PVector(0,0,0));
  }

  void face(PVector p_1,PVector p_2, PVector p_3) {
    vertex(p_1.x,p_1.y,p_1.z);
    vertex(p_2.x,p_2.y,p_2.z);
    vertex(p_3.x,p_3.y,p_3.z);
  }
  void DrawPyramid(PVector p_1,PVector p_2, PVector p_3, PVector p_4) {
    beginShape(TRIANGLES);
    face(p_1,p_2,p_3);
    face(p_1,p_2,p_4);
    face(p_1,p_3,p_4);
    face(p_2,p_3,p_4);
    endShape(CLOSE);
  }

  void DrawFindSphere(int x,int y, int z) {
    pushMatrix();
    translate(x,y,z);
    sphere(10);
    popMatrix();
  }

  void DrawRectangle(int w,int l, int h) {
    DrawFindSphere(w / 2, -l / 2, h / 2);
    beginShape(QUADS);
      vertex(w / 2, l / 2, h / 2);
      vertex(-w / 2, l / 2, h / 2);
      vertex(-w / 2, -l / 2, h / 2);
      vertex(w / 2, -l / 2, h / 2);

      vertex(-w / 2, -l / 2, h / 2);
      vertex(w / 2, -l / 2, h / 2);
      vertex(w / 2, -l / 2, -h / 2);
      vertex(-w / 2, -l / 2, -h / 2);

      vertex(w / 2, -l / 2, -h / 2);
      vertex(-w / 2, -l / 2, -h / 2);
      vertex(-w / 2, l / 2, -h / 2);
      vertex(w / 2, l / 2, -h / 2);

      vertex(w / 2, l / 2, -h / 2);
      vertex(w / 2, l / 2, h / 2);
      vertex(-w / 2, l / 2, h / 2);
      vertex(-w / 2, l / 2, -h / 2);

      vertex(-w / 2, -l / 2, -h / 2);
      vertex(-w / 2, l / 2, -h / 2);
      vertex(-w / 2, l / 2, h / 2);
      vertex(-w / 2, -l / 2, h / 2);

      vertex(w / 2, l / 2, -h / 2);
      vertex(w / 2, l / 2, h / 2);
      vertex(w / 2, -l / 2, h / 2);
      vertex(w / 2, -l / 2, -h / 2);


    endShape(CLOSE);
  }
}


class CoralDraw extends LSystem {
  void DrawChar(char c, int len) {
    if (c == 'F') {
      translate(0,len / 1.5,0);
    } else if (c == '[') {
      pushMatrix();
    } else if (c == ']') {
      popMatrix();
    } else if (c == '-') {
      rotateX(random(- PI / 6, PI / 15));
    } else if (c == '!') {
      rotateY(random(- PI / 6, PI / 15));
    } else if (c == '+') {
      rotateX(random(- PI / 15, PI / 6));
    } else if (c == '@') {
      rotateY(random(- PI / 15, PI / 6));
    } else if (c == 'A') {
      fill(color(255 - random(0,50),random(100,150),random(45,115)));
      if (random(0,50) < 5) {
        fill(color(113 - random(-30,30),random(238 - 50,255),random(169,200)));
      }
      sphereDetail(3);
      sphere(len);
      translate(random(-1,1),random(-1,1),random(-1,1));
    } else if (c == '%') {
      rotateZ(random(-PI / 4, PI / 4));
    }
  }
}

FullSystem MakeCoral() {
  CoralDraw draw = new CoralDraw();
  ArrayList<LRule> rules = new ArrayList<LRule>();
  String[] gotos = {"[A--FAFA]X[--F%!AF%FA]!FA","[A+F+F]X[FA!+!F][FAFA]"};
  rules.add(new StochLRule("A",gotos));
  String[] more_gotos = {"FAFA","FA!FA-FA"};
  rules.add(new StochLRule("F",more_gotos));
  rules.add(new LRule("X","%-%+!FAFA"));
  FullSystem ret = new FullSystem(draw,rules,"A",0,0,0);
  return ret;
}

class RockDraw extends LSystem {
  void DrawChar(char c, int len) {
    if (c == 'F') {
      translate(0,len / random(.3,3),0);
    } else if (c == '[') {
      pushMatrix();
    } else if (c == ']') {
      popMatrix();
    } else if (c == '-') {
      rotateX(random(- PI / 6, PI / 15));
    } else if (c == '!') {
      rotateY(random(- PI / 6, PI / 15));
    } else if (c == '+') {
      rotateX(random(- PI / 15, PI / 6));
    } else if (c == '@') {
      rotateY(random(- PI / 15, PI / 6));
    } else if (c == 'A') {
      // need to change the colors.
      fill(color(Pick(51),Pick(51),Pick(51)));
      if (random(0,50) < 5) {
        fill(color(Pick(6),Pick(6),Pick(6)));
      }
      sphereDetail(10);
      sphere(len * random(.5,3));

      translate(random(-1,1),random(-1,1),random(-1,1));
    } else if (c == '%') {
      rotateZ(random(-PI / 4, PI / 4));
    }
  }
}

float Pick(float a) {
  return random(a - 5,a + 5);
}

FullSystem MakeRock() {
  RockDraw draw = new RockDraw();
  ArrayList<LRule> rules = new ArrayList<LRule>();
  String[] gotos = {"[F-A--FAFA]X[--FF%!AF%FA]!FA","[A+F+F]X[FA!+!F][FAFA]"};
  rules.add(new StochLRule("A",gotos));
  String[] more_gotos = {"[--F+F@A]","[F%F!AF%F-]","[F]","[F]","F-F","F+F+F"};
  rules.add(new StochLRule("F",more_gotos));
  rules.add(new LRule("X","%-%+!FAFA"));
  FullSystem ret = new FullSystem(draw,rules,"A",0,0,0);
  ret.seed = second();
  return ret;
}