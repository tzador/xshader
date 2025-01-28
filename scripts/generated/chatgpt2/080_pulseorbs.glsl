vec4 f() {
  vec2 u = p * 2. - 1.;
  float o = 0.;
  for(int i = 0; i < 3; i++) o += exp(-length(u - vec2(S(t + i), C(t + i))) * 5.);
  return vec4(mix(vec3(.1, .5, 1.), vec3(1., .5, .1), o) * o, 1.);
}
