vec4 f() {
  vec2 u = p * 2. - 1.;
  float q = 0.;
  for(int i = 0; i < 3; i++) q += .1 / length(fract(u * 2. + vec2(S(t + i * 2.), C(t + i * 2.))) - .5);
  return vec4((.5 + .5 * C(q * 3. + vec3(0, 2, 4))) * exp(-length(u)), 1.);
}
