vec4 f() {
  vec2 u = p * 4. - 2.;
  float q = 0., r = length(u);

    // Primary quantum field
  for(int i = 0; i < 5; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .7;
    float d = length(u - v);
    q += exp(-d * 3.) * (1. + S(d * 8. - t * .628));
  }

    // Secondary interference pattern
  float w = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 c = fract(u * (.8 + float(i) * .4)) - vec2(.5);
    w += exp(-length(c) * 6.) * (1. + S(length(c) * 10. - t * .628 + float(i)));
  }

    // Combine patterns with color
  vec3 col = mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), q) * q +
    mix(vec3(.1, .8, .9), vec3(.9, .2, .8), w) * w * .5;

  return vec4(col * exp(-r * 1.2), 1.);
}
