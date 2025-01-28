vec4 f() {
  F2 u = p * 6. - 3.;
  F2 g = CELL(u), h = CELL(u + .5);
  F d = MN(MN(A(g.x), A(g.y)), MN(A(h.x), A(h.y)));
  F e = EX(-d * 8.);
  F2 v = CELL(u * ROT(t));
  F x = XOR(v.x, v.y);
  return F4(M(F3(.2, .8, .4), F3(.8, .2, 1.), e) + F3(.6, .8, .2) * EX(-x * 6.), O);
}
