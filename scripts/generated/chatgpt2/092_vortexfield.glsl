vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + log(r + .1) * 3. - mod(t, 10.) * .628;
  return vec4((.5 + .5 * C(a * 3. + vec3(0, 2, 4))) * exp(-pow(r - .5, 2.) * 3.), 1.);
}
