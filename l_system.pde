class LRule {
 String cur;
 String GoTo;

 public LRule() {}

 String GetId() {
  return cur;
 }

 LRule(String c, String gt) {
   cur = c;
   GoTo = gt;
 }

 String GetNext() {
   return GoTo;
 }

}

class StochLRule extends LRule {
 String cur;
 String[] GoTos;

 String GetId() {
  return cur;
 }

 StochLRule(String c, String[] Gt) {
  cur = c;
  GoTos = Gt;
  println(cur);
 }

 String GetNext() {
  return GoTos[(int)(random(0,GoTos.length))];
 }

}

class LSystem {
 void DrawChar(char c,int len) {}
}


LRule FindRule(String at, ArrayList<LRule> rules) {
  for (LRule rule : rules) {
    if (rule.GetId().equals(at)) return rule;
  }
  return (new LRule(at,at));
}

String NextL(String cur, ArrayList<LRule> rules) {
  String ret = "";
  for (int j = 0;j < cur.length();++j) {
     char i = cur.charAt(j);
     String it = "" + i;
     LRule rule = FindRule(it,rules);
     ret += rule.GetNext();
  }
  return ret;
}

void DrawL(String L, LSystem system,int len) {
 for (int j = 0;j < L.length();++j) {
   system.DrawChar(L.charAt(j),len);
 }
}

class FullSystem {
  LSystem lsystem;
  ArrayList<LRule> rules;
  String start;
  long seed;
  PVector pos;
  FullSystem(LSystem systm, ArrayList<LRule> rul,String str,int x, int y, int z) {
    lsystem = systm;
    rules = rul;
    start = str;
    pos = new PVector(x,y,z);
  }

  void Draw(int i,int len) {
     randomSeed(seed);
     noStroke();
     if (start.length() < 5){
       for (int q = 0;q < i;++q) start = NextL(start,rules);
     }
     pushMatrix();
     translate(pos.x,pos.y,pos.z);
     DrawL(start,lsystem,len);
     popMatrix();
  }
}
