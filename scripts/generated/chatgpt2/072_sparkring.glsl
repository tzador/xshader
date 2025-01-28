vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float s = pow(.1 / abs(r - .5 + .1 * S(atan(u.y, u.x) * 8. + t * 3.)), 2.);
  return vec4(mix(vec3(.1, .5, 1.), vec3(1., .8, .2), s) * s, 1.);
}
