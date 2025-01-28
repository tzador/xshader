vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);
  float h = 0.;
  for(int i = 0; i < 5; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.5), C(t * .628 + i * 2.5)) * .7;
    float d = length(u - v);
    h += exp(-d * 4.) * (1. + .5 * S(d * 10. - t * .628));
  }
  float w = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 g = abs(fract(u * mat2(C(t * .314 + i), S(t * .314 + i), -S(t * .314 + i), C(t * .314 + i)) * 2.) - vec2(.5));
    w += exp(-length(g) * 6.);
  }
  float e = exp(-abs(r - .7 + .2 * S(t * .628)) * 5.);
  vec3 col = mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), h) * h + mix(vec3(.1, .8, .9), vec3(.9, .2, .8), w) * w + vec3(.7, .5, 1.) * e;
  return vec4(col * exp(-r * 1.2), 1.);
}
