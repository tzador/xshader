vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u), e = EX(-A(r - H - H * S(t)) * 6.);
  F2 v = CELL(u * ROT(t));
  F d = XOR(v.x, v.y);
  F3 c = M(F3(.2, .5, 1.), F3(.8, .2, 1.), e) + F3(.6, .3, .9) * EX(-d * 5.);
  return F4(c * ST(O, Z, r), O);
}
