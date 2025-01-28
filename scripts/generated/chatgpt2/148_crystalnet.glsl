vec4 f() {
  F2 u = p * 6. - 3.;
  F x = 0.;
  for(int i = 0; i < 3; i++) {
    F2 v = CELL(u * ROT(i * P / 3. + t));
    x += EX(-L(v) * 5.);
  }
  F2 g = CELL(u + F2(S(t), C(t)));
  F y = XOR(g.x, g.y);
  F3 c = M(F3(.2, .6, 1.), F3(.8, .3, .9), x) * x + F3(.7, .4, 1.) * EX(-y * 6.);
  return F4(c * EX(-L(u) * .8), O);
}
