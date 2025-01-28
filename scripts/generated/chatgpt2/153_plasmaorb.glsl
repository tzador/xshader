vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u);
  F e = EX(-A(r - H - H * S(t)) * 8.);
  F w = 0.;
  for(int i = 0; i < 3; i++) w += S(D(N(u), F2(S(t + i * Q / 3.), C(t + i * Q / 3.))) * 4.);
  return F4(M(F3(.2, .5, 1.), F3(.8, .2, 1.), e) * e + F3(.6, .3, .9) * w * ST(O, H, r), O);
}
