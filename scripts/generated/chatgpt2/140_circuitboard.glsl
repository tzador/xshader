vec4 f() {
  vec2 u = p * 6. - 3.;
  vec2 g = abs(fract(u) - .5), h = abs(fract(u + .5) - .5);
  float d = min(min(g.x, g.y), min(h.x, h.y));
  float c = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 v = floor(u) + vec2(i / 2, i % 2);
    float p = S(v.x * .7 + v.y * .9 + t * 2.);
    c += smoothstep(.1, .0, abs(length(fract(u) - vec2(i / 2, i % 2)) - .3 + .1 * p));
  }
  vec3 col = mix(vec3(.1, .2, .15), vec3(.2, .8, .4), smoothstep(.05, .0, d)) + vec3(.0, .5, .2) * c;
  return vec4(col, 1.);
}
