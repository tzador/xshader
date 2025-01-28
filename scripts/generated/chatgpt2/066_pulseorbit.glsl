vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x);
  float p = pow(.5 + .5 * S(r * 8. - a * 3. + t * 2.), 4.);
  return vec4(mix(vec3(.1, .5, .9), vec3(.9, .3, .1), p) * p, 1.);
}
