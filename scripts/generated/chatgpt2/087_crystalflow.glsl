vec4 f() {
  vec2 u = p * 2. - 1.;
  float a = atan(u.y, u.x) * 5.;
  float r = length(u);
  float c = abs(mod(a + r * 3. - mod(t, 10.) * .628, 2.) - 1.);
  return vec4(mix(vec3(.2, .8, 1.), vec3(.8, .2, 1.), .1 / c) * exp(-r * 2.), 1.);
}
