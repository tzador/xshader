vec4 f() {
  vec2 u = p * 2. - 1.;
  float w = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 c = vec2(S(i * 2.), C(i * 2.)) * .5;
    w += S(length(u - c) * 8. - t * .628);
  }
  return vec4((.5 + .5 * C(w * 3. + vec3(0, 2, 4))) * exp(-length(u) * 2.), 1.);
}
