vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + r * 3. - t;
  vec3 c = vec3(.2, .5, 1.) * (.1 / abs(r - .5 + .1 * S(a * 6.)));
  return vec4(c, 1.);
}
