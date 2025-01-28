vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);
  float p1 = 0.;
  for(int i = 0; i < 5; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .7;
    float d = length(u - v);
    p1 += exp(-d * 4.) * (1. + .5 * S(d * 10. - t * .628));
  }
  float p2 = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2.;
    vec2 v = u * mat2(C(a + t * .314), S(a + t * .314), -S(a + t * .314), C(a + t * .314));
    vec2 g = abs(fract(v * 2.) - vec2(.5));
    p2 += exp(-length(g) * 6.) * .5;
  }
  float p3 = exp(-abs(r - .7 + .15 * S(t * .628)) * 7.);
  vec3 col = mix(vec3(.2, .6, 1.), vec3(.9, .3, .8), p1) * p1 + mix(vec3(.1, .7, .9), vec3(.8, .2, .7), p2) * p2 + vec3(.7, .4, 1.) * p3;
  return vec4(col * exp(-r * 1.3), 1.);
}
