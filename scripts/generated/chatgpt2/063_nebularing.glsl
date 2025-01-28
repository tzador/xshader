vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) * 3.;
  float n = S(r - .5 + .2 * S(a + t)) * S(a * 2. - t * 3.);
  return vec4(mix(vec3(.5, .2, 1.), vec3(.2, .5, 1.), n) * n, 1.);
}
