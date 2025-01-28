vec4 f() {
  vec2 u = p * 4. - 2.;
  float d = abs(u.x) + abs(u.y), w = S(d * 4. - t * .628);
  vec2 g = abs(fract(u * 2.) - .5);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), w) * exp(-(d + length(g)) * 2.), 1.);
}
