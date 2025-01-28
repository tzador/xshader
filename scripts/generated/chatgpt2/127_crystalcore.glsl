vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);

    // Crystal lattice
  float c = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2.;
    vec2 v = u * mat2(C(a), S(a), -S(a), C(a));
    vec2 g = abs(fract(v * (1. + float(i) * .2)) - vec2(.5));
    c += exp(-max(g.x, g.y) * 6.) * (1. + S(max(g.x, g.y) * 12. - t * .628));
  }

    // Energy pulse
  float e = 0.;
  for(int i = 0; i < 3; i++) {
    float d = abs(r - .5 - float(i) * .2 + .1 * S(t * .628 + float(i)));
    e += exp(-d * 8.) * (1. + S(d * 20. - t * .628));
  }

    // Combine with color
  vec3 col = mix(vec3(.2, .8, 1.), vec3(.9, .2, .8), c) * c +
    mix(vec3(.1, .5, 1.), vec3(1., .3, .5), e) * e;

  return vec4(col * exp(-r * 1.5), 1.);
}
