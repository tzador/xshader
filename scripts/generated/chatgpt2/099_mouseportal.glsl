vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  float a = atan(d.y, d.x) + mod(t, 10.) * .628;
  float w = .1 / abs(r - .5 + .2 * S(a * 5.));
  return vec4((.5 + .5 * C(a * 2. + vec3(0, 2, 4))) * w * exp(-r * 2.), 1.);
}
