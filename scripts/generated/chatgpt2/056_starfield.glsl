vec4 f() {
  vec2 u = p * 4. - 2.;
  u += vec2(S(t), C(t)) * .2;
  vec2 g = fract(u) - .5;
  float s = pow(.01 / length(g), 2.) * step(.99, fract(length(u) + t));
  return vec4(vec3(s), 1.);
}
