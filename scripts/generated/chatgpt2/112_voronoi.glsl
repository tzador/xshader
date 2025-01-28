vec4 f() {
  vec2 u = p * 3. - 1.5;
  float m = 9.;
  for(int i = 0; i < 6; i++) {
    vec2 v = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.));
    m = min(m, length(fract(u + v) - .5));
  }
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), m) * exp(-m * 3.), 1.);
}
