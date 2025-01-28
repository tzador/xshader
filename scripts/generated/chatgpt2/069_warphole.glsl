vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + 1. / r - t;
  vec3 c = .5 + .5 * C(a * 5. + vec3(0, 2, 4));
  return vec4(c * exp(-pow(r - .5, 2.) * 3.), 1.);
}
