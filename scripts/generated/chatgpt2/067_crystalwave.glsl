vec4 f() {
  vec2 u = p * 2. - 1.;
  float a = atan(u.y, u.x) * 5.;
  float r = length(u);
  float c = abs(mod(a + r * 3. - t, 2.) - 1.);
  return vec4(vec3(.2, .5, 1.) * (.1 / c) * exp(-r * 2.), 1.);
}
