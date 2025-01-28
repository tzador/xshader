vec4 f() {
  F2 u = p * 3. - 1.5;
  F g = 0., a = 1.;
  for(int i = 0; i < 3; i++) {
    F2 v = u;
    for(int j = 0; j < 2; j++) v = F2(v.x * v.x - v.y * v.y, 2. * v.x * v.y) * .5 + F2(S(t + i), C(t + i));
    g += EX(-L(v) * 2.) * a;
    a *= .5;
  }
  return F4(M(F3(.2, .5, 1.), F3(.8, .2, 1.), g) * g, O);
}
