vec4 f() {
  vec2 u = p * 2. - 1.;
  float a = atan(u.y, u.x);
  float r = length(u);
  float f = pow(.5 + .5 * S(r * 6. - a * 2. - t * 3.), 3.);
  return vec4(mix(vec3(1., .2, 0.), vec3(1., .8, .1), f) * f, 1.);
}
