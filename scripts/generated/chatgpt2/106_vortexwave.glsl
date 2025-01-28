vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + log(r + .1) * 2. - t * .628;
  float w = .1 / abs(mod(a + r, 1.) - .5);
  return vec4((.5 + .5 * C(a * 2. + vec3(0, 2, 4))) * w * exp(-r * 2.), 1.);
}
