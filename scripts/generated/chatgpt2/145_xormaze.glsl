vec4 f() {
  vec2 u = p * 8. - 4.;
  float m = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = abs(fract(u * (1. + float(i) * .5)) - .5);
    float d = abs(v.x - v.y);
    vec2 w = abs(fract(u * (1. + float(i) * .5) + .5) - .5);
    float e = abs(w.x - w.y);
    m += smoothstep(.1, .0, min(d, e));
  }
  float x = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 v = abs(fract(u + vec2(S(t * .628 + float(i)), C(t * .628 + float(i)))) - .5);
    x += exp(-abs(v.x - v.y) * 6.);
  }
  vec3 col = mix(vec3(.1, .2, .3), vec3(.2, .6, .8), m) + vec3(.4, .6, .8) * x;
  return vec4(col, 1.);
}
