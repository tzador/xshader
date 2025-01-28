vec4 f() {
  vec2 u = p * 2. - 1.;
  float a = atan(u.y, u.x);
  float r = length(u);
  float b = .1 / abs(mod(a + r - t * 2., 1.) - .5);
  vec3 c = mix(vec3(.2, .5, 1.), vec3(1., .5, .2), r) * b * exp(-r * 2.);
  return vec4(c, 1.);
}
