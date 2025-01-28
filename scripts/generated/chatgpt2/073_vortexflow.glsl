vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float v = atan(u.y, u.x) + log(r + .1) * 3. - t;
  return vec4((.5 + .5 * C(v * 3. + vec3(0, 2, 4))) * exp(-r * 2.), 1.);
}
