vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);

    // Web nodes
  float n = 0.;
  for(int i = 0; i < 6; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .8;
    float d = length(u - v);
    n += exp(-d * 4.) * (1. + .5 * S(d * 10. - t * .628));
  }

    // Energy connections
  float e = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2.;
    vec2 v = u * mat2(C(a + t * .314), S(a + t * .314), -S(a + t * .314), C(a + t * .314));
    vec2 g = abs(fract(v * 2.) - vec2(.5));
    e += exp(-length(g) * 6.) * .5;
  }

    // Combine with plasma effect
  vec3 col = mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), n) * n +
    mix(vec3(.1, .8, .9), vec3(.9, .2, .8), e) * e;

  return vec4(col * exp(-r * 1.2), 1.);
}
