vec4 f() {
  F2 u = p * 4. - 2.;
  F r = L(u), a = atan(u.y, u.x);
  F2 v = F2(r * C(a + t), r * S(a - t));
  F d = XOR(CELL(v).x, CELL(v * 1.5).y);
  return F4(M(F3(.2, .5, 1.), F3(.8, .2, 1.), ST(Z, .2, d)) * EX(-r + d * .2), O);
}
