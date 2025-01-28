vec4 f() {
  vec2 u = p * 2. - 1.;
  float v = S(u.x + t) + S(u.y - t) + S(length(u) * 3. - t * 2.);
  vec3 c = .5 + .5 * C(v * 5. + vec3(0, 2, 4));
  return vec4(c * exp(-length(u)), 1.);
}
