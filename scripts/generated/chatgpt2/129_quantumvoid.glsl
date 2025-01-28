vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);

    // Quantum particles
  float q = 0.;
  for(int i = 0; i < 5; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.5), C(t * .628 + i * 2.5)) * .7;
    float d = length(u - v);
    q += exp(-d * 5.) * (1. + .5 * S(d * 12. - t * .628 + float(i)));
  }

    // Void field
  float f = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = fract(u * (1.2 + float(i) * .3) + vec2(t * .2)) - vec2(.5);
    f += exp(-length(v) * 8.) * (1. + .3 * S(length(v) * 15. - t * .628));
  }

    // Energy ripples
  float e = exp(-abs(r - .8 + .2 * S(t * .628)) * 6.);

    // Combine effects
  vec3 col = mix(vec3(.1, .5, 1.), vec3(.8, .2, 1.), q) * q +
    mix(vec3(.2, .8, .9), vec3(.9, .2, .8), f) * f +
    vec3(.8, .5, 1.) * e;

  return vec4(col * exp(-r * 1.3), 1.);
}
