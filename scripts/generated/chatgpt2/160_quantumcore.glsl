vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u);
  F q = 0.;
  for(int i = 0; i < 4; i++) {
    F2 v = F2(S(t * 2. + i * P / 2.), C(t * 2. + i * P / 2.)) * .7;
    q += EX(-L(u - v) * 4.);
  }
  F e = EX(-A(r - H - H * S(t)) * 6.);
  return F4(M(F3(.2, .5, 1.), F3(.8, .2, 1.), q) * q + F3(.6, .3, .9) * e, O);
}
