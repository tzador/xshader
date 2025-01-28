vec4 f() {
  vec2 u = p * 2. - 1.;
  float s = pow(.5 + .5 * S(length(u) * 6. - atan(u.y, u.x) * 2. + t * 3.), 8.);
  return vec4(mix(vec3(.2, .5, 1.), vec3(1., .8, .2), s) * s, 1.);
}
