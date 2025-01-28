vec4 f() {
  vec2 u = p * 3. - 1.5;
  vec2 g = abs(fract(u) - .5);
  float d = max(g.x, g.y), w = S(d * 6. - t * .628);
  return vec4((.5 + .5 * C(w * 8. + length(u) + vec3(0, 2, 4))) * exp(-d * 4.), 1.);
}
