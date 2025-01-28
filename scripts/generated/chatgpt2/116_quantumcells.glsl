vec4 f() {
  vec2 u = p * 5. - 2.5;
  float q = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 v = fract(u + vec2(S(t * .628 + i), C(t * .628 + i))) - .5;
    q = max(q, exp(-length(v) * 8.));
  }
  return vec4((.5 + .5 * C(q * 6. + vec3(0, 2, 4))) * smoothstep(.8, 0., length(p - .5)), 1.);
}
