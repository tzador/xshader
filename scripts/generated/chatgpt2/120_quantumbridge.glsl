vec4 f() {
  vec2 u = p * 4. - 2.;
  float q = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = vec2(S(i * 2.), C(i * 2.)) * .7;
    q += exp(-abs(length(u - v) - length(u + v)) * 3.);
  }
  return vec4((.5 + .5 * C(q * 4. + vec3(0, 2, 4))) * exp(-length(u) * 1.5), 1.);
}
