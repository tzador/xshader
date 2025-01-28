vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);
  float e1 = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2. + t * .314;
    vec2 v = u * mat2(C(a), S(a), -S(a), C(a));
    vec2 g = abs(fract(v * (1.2 + float(i) * .3)) - vec2(.5));
    e1 += exp(-length(g) * 5.) * (1. + .4 * S(length(g) * 12. - t * .628));
  }
  float e2 = 0.;
  for(int i = 0; i < 3; i++) {
    float d = abs(r - .5 - float(i) * .25 + .1 * S(t * .628 + float(i)));
    e2 += exp(-d * 8.) * (1. + .3 * S(d * 15. - t * .628));
  }
  float e3 = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .6;
    e3 += exp(-length(u - v) * 6.);
  }
  vec3 col = mix(vec3(.2, .6, 1.), vec3(.9, .3, .8), e1) * e1 + mix(vec3(.1, .7, .9), vec3(.8, .2, .7), e2) * e2 + vec3(.7, .4, 1.) * e3;
  return vec4(col * exp(-r * 1.4), 1.);
}
