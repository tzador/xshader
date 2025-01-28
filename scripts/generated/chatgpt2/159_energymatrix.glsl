vec4 f() {
  F2 u = p * 8. - 4.;
  F e = 0.;
  for(int i = 0; i < 3; i++) {
    F2 g = CELL(u * ROT(t * .5 + i * P / 3.));
    F2 h = CELL(u * ROT(t * .5 + i * P / 3.) + .5);
    e += ST(.1, 0., MN(L(g), L(h)));
  }
  return F4(M(F3(.2, .6, 1.), F3(.8, .3, .9), e) + F3(.6, .4, 1.) * e * S(t * 2.), O);
}
