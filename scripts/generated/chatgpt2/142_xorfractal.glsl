vec4 f() {
  vec2 u = p * 8. - 4.;
  float x = 0., a = 1.;
  for(int i = 0; i < 4; i++) {
    vec2 v = abs(fract(u * a) - .5);
    float d = abs(v.x - v.y);
    vec2 w = abs(fract(u * a + .5) - .5);
    float e = abs(w.x - w.y);
    x += exp(-min(d, e) * 8.) * a;
    a *= .5;
  }
  vec2 g = abs(fract(u + vec2(S(t * .628), C(t * .628))) - .5);
  float y = abs(g.x - g.y);
  vec3 col = mix(vec3(.1, .4, .7), vec3(.7, .2, .8), x) + vec3(.6, .3, .9) * exp(-y * 6.);
  return vec4(col, 1.);
}
