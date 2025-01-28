vec4 f() {
  vec2 u = p * 2. - 1.;
  float e = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 w = u + vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .3;
    e += .1 / length(fract(w * 3.) - .5);
  }
  return vec4((.5 + .5 * C(e * 2. + vec3(0, 2, 4))) * exp(-length(u) * 2.), 1.);
}
