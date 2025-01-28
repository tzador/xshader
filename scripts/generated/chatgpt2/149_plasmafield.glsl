vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u);
  F w = 0.;
  for(int i = 0; i < 3; i++) w += S(D(N(u), F2(S(t + i * Q / 3.), C(t + i * Q / 3.))) * 3.);
  F3 c = M(F3(.2, .5, 1.), F3(.8, .2, 1.), ST(Z, O, w + H)) * ST(O, H, r);
  return F4(c, O);
}
