vec4 f() {
  vec2 u = p * 6. - 3.;
  float x = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = abs(fract(u + vec2(t * .2 + float(i) * .2, t * .3 + float(i) * .3)) - .5);
    float d = abs(v.x - v.y);
    x += exp(-d * 5.) * (1. + .4 * S(d * 10. - t * .628));
  }
  float y = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 v = abs(fract(u * mat2(C(t * .314 + float(i)), S(t * .314 + float(i)), -S(t * .314 + float(i)), C(t * .314 + float(i)))) - .5);
    y += exp(-abs(v.x - v.y) * 6.);
  }
  vec3 col = mix(vec3(.2, .4, .8), vec3(.8, .3, .9), x) * x + mix(vec3(.3, .5, .9), vec3(.9, .4, .8), y) * y;
  return vec4(col * exp(-length(u) * .6), 1.);
}
