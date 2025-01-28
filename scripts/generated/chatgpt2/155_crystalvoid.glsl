vec4 f() {
  F2 u = p * 8. - 4.;
  F c = 0., a = 1.;
  for(int i = 0; i < 3; i++) {
    F2 v = CELL(u * a * ROT(t + i));
    F d = XOR(v.x, v.y);
    c += EX(-d * 6.) * a;
    a *= .5;
  }
  return F4(M(F3(.2, .6, 1.), F3(.8, .3, .9), c) * c * EX(-L(u) * .4), O);
}
