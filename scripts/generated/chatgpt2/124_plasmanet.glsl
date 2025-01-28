vec4 f() {
  vec2 u = p * 4. - 2.;
  float n = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = vec2(S(i * 2.), C(i * 2.));
    n += exp(-abs(dot(normalize(u - v), normalize(u + v))) * 5.);
  }
  return vec4((.5 + .5 * C(n * 3. + vec3(0, 2, 4))) * exp(-length(u) * 2.), 1.);
}
