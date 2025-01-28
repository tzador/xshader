vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float o = 0.;
  for(int i = 0; i < 3; i++) o += exp(-length(u - vec2(S(mod(t, 10.) * .628 + i * 2.), C(mod(t, 10.) * .628 + i * 2.))) * 3.);
  return vec4(mix(vec3(.2, .5, 1.), vec3(1., .5, .2), o) * o, 1.);
}
