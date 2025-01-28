vec4 f() {
  F2 u = p * 6. - 3.;
  F x = 0.;
  for(int i = 0; i < 3; i++) {
    F2 v = u * ROT(t * .5 + i * P / 3.);
    F2 g = CELL(v);
    x += EX(-L(g) * 4.) * (O + H * S(L(g) * 8. - t));
  }
  return F4(M(F3(.2, .5, 1.), F3(.8, .2, 1.), x) * x * EX(-L(u) * .8), O);
}
