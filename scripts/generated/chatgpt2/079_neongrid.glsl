vec4 f() {
  vec2 u = p * 6. - 3. + S(t + u.yx);
  vec2 g = abs(fract(u) - .5);
  float d = .1 / min(g.x, g.y);
  return vec4(mix(vec3(.2, .8, 1.), vec3(.8, .2, 1.), d) * d * exp(-length(p * 2. - 1.)), 1.);
}
