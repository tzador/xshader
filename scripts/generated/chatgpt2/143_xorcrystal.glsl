vec4 f() {
  vec2 u = p * 6. - 3.;
  float x = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2. + t * .314;
    vec2 v = u * mat2(C(a), S(a), -S(a), C(a));
    vec2 g = abs(fract(v) - .5);
    float d = abs(g.x - g.y);
    x += exp(-d * 6.) * (1. + .3 * S(d * 12. - t * .628));
  }
  float r = length(u);
  vec2 w = abs(fract(u * (1. + .2 * S(t * .628))) - .5);
  float y = abs(w.x - w.y);
  vec3 col = mix(vec3(.2, .5, .8), vec3(.8, .3, .9), x) * x + vec3(.6, .4, 1.) * exp(-y * 8.);
  return vec4(col * exp(-r * .8), 1.);
}
