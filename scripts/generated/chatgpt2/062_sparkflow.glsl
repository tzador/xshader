vec4 f() {
  vec2 u = p * 2. - 1.;
  float a = atan(u.y, u.x);
  float r = length(u);
  float s = pow(.5 + .5 * S(r * 6. - a * 2. + t * 3.), 8.);
  return vec4(mix(vec3(.2, .5, 1.), vec3(1., .8, .2), s) * s, 1.);
}
