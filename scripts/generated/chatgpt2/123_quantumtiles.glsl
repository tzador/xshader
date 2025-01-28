vec4 f() {
  vec2 u = p * 6. - 3.;
  vec2 g = abs(fract(u) - .5), h = abs(fract(u + .5) - .5);
  float d = min(max(g.x, g.y), max(h.x, h.y));
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), S(d * 8. - t * .628)) * exp(-d * 4.), 1.);
}
