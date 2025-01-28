vec4 f() {
  vec2 u = p * 3. - 1.5;
  vec2 g = abs(fract(u + vec2(S(t * .628), C(t * .628))) - .5);
  float d = max(g.x, g.y);
  return vec4(mix(vec3(.2, .8, 1.), vec3(.8, .2, 1.), smoothstep(.1, .2, d)) * exp(-d * 4.), 1.);
}
