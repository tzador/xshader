vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + r * 3. - mod(t, 10.) * .628;
  float s = .1 / abs(mod(a, 1.) - .5);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), r) * s * exp(-r * 2.), 1.);
}
