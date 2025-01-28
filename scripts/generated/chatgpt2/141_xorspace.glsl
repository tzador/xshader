vec4 f() {
  vec2 u = p * 6. - 3.;
  float x = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = abs(fract(u * (1. + float(i) * .5)) - .5);
    float d = abs(v.x - v.y) * 2.;
    x += exp(-d * 6.) * (1. + .5 * S(d * 8. - t * .628 + float(i)));
  }
  vec2 g = abs(fract(u * mat2(C(t * .314), S(t * .314), -S(t * .314), C(t * .314))) - .5);
  float y = exp(-abs(g.x - g.y) * 8.);
  vec3 col = mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), x) * x + vec3(.7, .3, .9) * y;
  return vec4(col * exp(-length(u) * .5), 1.);
}
