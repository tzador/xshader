vec4 f() {
  vec2 u = p * 4. - 2.;
  vec2 g = abs(fract(u) - .5);
  float d = length(g), n = S(d * 8. - t * .628);
  vec2 h = abs(fract(u + .5) - .5);
  float e = length(h);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), min(n, S(e * 8. - t * .628 + .5))) * exp(-min(d, e) * 4.), 1.);
}
