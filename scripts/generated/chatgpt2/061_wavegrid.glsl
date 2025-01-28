vec4 f() {
  vec2 u = p * 6. - 3.;
  vec2 g = abs(fract(u - .5) - .5);
  float d = min(g.x, g.y);
  float w = S(length(u) * .5 - t);
  vec3 c = vec3(.2, .5, 1.) * (.1 / d) * w;
  return vec4(c * exp(-length(p * 2. - 1.)), 1.);
}
