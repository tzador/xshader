vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  float w = S(r * 8. - mod(t, 10.) * .628);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), r) * w * exp(-r * 2.), 1.);
}
