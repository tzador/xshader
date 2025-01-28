vec4 f() {
  vec2 u = p * 4. - 2., h = u * mat2(.866, -.5, .5, .866);
  vec2 g = abs(fract(h) - .5);
  float d = min(max(g.x * .866 + g.y * .5, g.y), length(g));
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), S(t * .628)) * exp(-d * 4.), 1.);
}
