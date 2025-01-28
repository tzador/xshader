vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  float a = atan(d.y, d.x) + log(r + .1) * 3. - mod(t, 10.) * .628;
  float s = .1 / abs(mod(a, 1.) - .5);
  return vec4((.5 + .5 * C(a * 3. + vec3(0, 2, 4))) * s * exp(-r * 2.), 1.);
}
