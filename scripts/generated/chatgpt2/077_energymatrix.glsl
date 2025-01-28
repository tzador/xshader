vec4 f() {
  vec2 u = p * 4. - 2.;
  vec2 g = abs(fract(u - t * .2) - .5);
  float d = exp(-min(g.x, g.y) * 3.);
  return vec4(mix(vec3(.1, .5, 1.), vec3(.5, .1, 1.), d) * d, 1.);
}
