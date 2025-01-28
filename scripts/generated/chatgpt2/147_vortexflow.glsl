vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u);
  F2 v = u * ROT(r - t);
  F d = XOR(CELL(v).x, CELL(v).y);
  F3 c = M(F3(.2, .5, 1.), F3(.8, .2, 1.), ST(Z, .2, d)) + F3(.6, .3, .9) * EX(-d * 6.);
  return F4(c * EX(-r), O);
}
