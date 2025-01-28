vec4 f() {
  vec2 u = p * 2. - 1.;
  float q = 0.;
  for(int i = 0; i < 3; i++) q += .1 / length(fract(u * 2. + vec2(S(mod(t, 10.) * .628 + i), C(mod(t, 10.) * .628 + i))) - .5);
  return vec4((.5 + .5 * C(q * 4. + vec3(0, 2, 4))) * exp(-length(u)), 1.);
}
