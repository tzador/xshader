vec4 f() {
  vec2 u = p * 5. - 2.5;
  vec2 g = fract(u) - .5;
  float e = 0.;
  for(int i = 0; i < 4; i++) e += exp(-length(g + vec2(S(t * .628 + i), C(t * .628 + i)) * .2) * 8.);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), e) * e, 1.);
}
