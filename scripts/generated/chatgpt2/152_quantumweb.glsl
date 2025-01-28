vec4 f() {
  F2 u = p * 6. - 3.;
  F q = 0.;
  for(int i = 0; i < 4; i++) {
    F2 v = CELL(u * ROT(t + i * P / 2.));
    q += EX(-L(v) * 6.);
  }
  F2 w = CELL(u * ROT(-t));
  F d = XOR(w.x, w.y);
  return F4(M(F3(.2, .6, 1.), F3(.8, .3, .9), q) * q + F3(.6, .4, 1.) * EX(-d * 8.), O);
}
