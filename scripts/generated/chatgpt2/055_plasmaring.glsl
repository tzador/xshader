vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x);
  float p = S(r * 5. - t) + .5 * S(a * 6. + t * 2.);
  vec3 c = .5 + .5 * C(p * 6. + vec3(0, 2, 4));
  return vec4(c * exp(-r * 2.), 1.);
}
