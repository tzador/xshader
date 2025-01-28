vec4 f() {
  vec2 u = p * 3. - 1.5;
  float c = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = abs(fract(u * mat2(1, 1, -1, 1) * (1. + float(i) * .5)) - .5);
    c += exp(-max(v.x, v.y) * 5.);
  }
  return vec4(mix(vec3(.2, .8, 1.), vec3(.8, .2, 1.), S(t * .628)) * c, 1.);
}
