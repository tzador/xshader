vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u), q = 0.;
  for(int i = 0; i < 4; i++) {
    F2 v = F2(S(t + i * 2.), C(t + i * 2.)) * .7;
    q += EX(-L(u - v) * 3.) * (O + H * S(L(u - v) * 8. - t));
  }
  F3 c = M(F3(.2, .5, 1.), F3(.8, .2, 1.), q) * q;
  return F4(c * EX(-r), O);
}
