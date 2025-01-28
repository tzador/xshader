vec4 f() {
  vec2 u = p * 5. - 2.5;
  vec2 g = abs(fract(u) - .5);
  float d = min(g.x, g.y);
  float p = S(mod(t, 10.) * .628) * 2.;
  return vec4(mix(vec3(.1, .5, 1.), vec3(.8, .2, 1.), exp(-d * p)) * exp(-d * 3.), 1.);
}
