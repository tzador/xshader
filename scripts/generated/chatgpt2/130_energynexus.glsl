vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);

    // Primary energy field
  float e1 = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2. + t * .314;
    vec2 v = u * mat2(C(a), S(a), -S(a), C(a));
    vec2 g = abs(fract(v * 2.) - vec2(.5));
    e1 += exp(-length(g) * 5.) * (1. + .4 * S(length(g) * 12. - t * .628));
  }

    // Secondary pattern
  float e2 = 0.;
  for(int i = 0; i < 5; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .8;
    float d = length(u - v);
    e2 += exp(-d * 4.) * (1. + .3 * S(d * 10. - t * .628));
  }

    // Geometric overlay
  vec2 g = abs(fract(u * (1. + .2 * S(t * .628))) - vec2(.5));
  float e3 = exp(-max(g.x, g.y) * 6.);

    // Combine all effects
  vec3 col = mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), e1) * e1 +
    mix(vec3(.1, .8, .9), vec3(.9, .2, .8), e2) * e2 +
    vec3(.7, .5, 1.) * e3;

  return vec4(col * exp(-r * 1.4), 1.);
}
