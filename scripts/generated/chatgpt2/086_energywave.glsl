vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float w = S(r * 5. - mod(t, 10.) * .628) + S(atan(u.y, u.x) * 3.);
  return vec4((.5 + .5 * C(w * 5. + vec3(0, 2, 4))) * exp(-r * 2.), 1.);
}
