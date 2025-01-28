vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x);
  float n = .1 / abs(mod(a * 3. + r * 2. - t * .628, 1.) - .5);
  return vec4((.5 + .5 * C(a + vec3(0, 2, 4))) * n * exp(-r * 2.), 1.);
}
