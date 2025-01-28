vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x);
  float p = S(r * 6. - t * .628) + S(a * 5.);
  return vec4((.5 + .5 * C(p * 4. + vec3(0, 2, 4))) * exp(-pow(r - .5, 2.) * 4.), 1.);
}
