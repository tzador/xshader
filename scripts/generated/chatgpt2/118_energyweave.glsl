vec4 f() {
  vec2 u = p * 4. - 2.;
  float e = 0.;
  for(int i = 0; i < 2; i++) {
    vec2 v = abs(fract(u * mat2(C(i + t * .628), S(i + t * .628), -S(i + t * .628), C(i + t * .628))) - .5);
    e += exp(-min(v.x, v.y) * 8.);
  }
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), e) * e, 1.);
}
