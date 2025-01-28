vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  float w = S(r * 6. - mod(t, 10.) * .628) + S(atan(d.y, d.x) * 3.);
  return vec4((.5 + .5 * C(w * 6. + vec3(0, 2, 4))) * exp(-r * 2.), 1.);
}
