vec4 f() {
  vec2 u = p * 2. - 1.;
  float q = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 v = fract(u * 2. + vec2(S(t * .628 + i), C(t * .628 + i))) - .5;
    q += .1 / length(v);
  }
  return vec4((.5 + .5 * C(q * 3. + vec3(0, 2, 4))) * exp(-length(u) * 2.), 1.);
}
