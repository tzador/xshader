vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);
  float q1 = 0.;
  for(int i = 0; i < 6; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .8;
    float d = length(u - v);
    q1 += exp(-d * 5.) * (1. + .4 * S(d * 12. - t * .628));
  }
  float q2 = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 c = fract(u * (1. + float(i) * .3) + vec2(t * .2)) - vec2(.5);
    q2 += exp(-length(c) * 7.) * (1. + .3 * S(length(c) * 15. - t * .628));
  }
  float q3 = 0.;
  for(int i = 0; i < 3; i++) {
    float d = abs(r - .6 - float(i) * .2 + .1 * S(t * .628));
    q3 += exp(-d * 8.);
  }
  vec3 col = mix(vec3(.1, .5, 1.), vec3(.8, .2, 1.), q1) * q1 + mix(vec3(.2, .8, .9), vec3(.9, .2, .8), q2) * q2 + vec3(.7, .5, 1.) * q3;
  return vec4(col * exp(-r * 1.3), 1.);
}
