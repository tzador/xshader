vec4 f() {
  F2 u = p * 4. - 2.;
  F w = 0.;
  for(int i = 0; i < 4; i++) w += S(D(u, F2(S(t + i * P / 2.), C(t + i * P / 2.))) * 3. - L(u));
  F3 c = M(F3(.2, .5, 1.), F3(.8, .2, 1.), ST(Z, O, w + H)) * ST(O, H, L(u));
  return F4(c, O);
}
