vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + r * 2. - mod(t, 10.) * .628;
  float s = .1 / abs(mod(a, 1.) - .5);
  return vec4((.5 + .5 * C(a + vec3(0, 2, 4))) * s * exp(-r * 2.), 1.);
}
