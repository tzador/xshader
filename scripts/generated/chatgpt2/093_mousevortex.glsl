vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  float a = atan(d.y, d.x) - r * 2. - mod(t, 10.) * .628;
  float s = .1 / abs(mod(a, 1.) - .5);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), r) * s * exp(-r * 3.), 1.);
}
