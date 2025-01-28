vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  vec2 g = abs(fract(u * 3. + d * .5) - .5);
  float l = min(g.x, g.y);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), length(d)) * exp(-l * 3.), 1.);
}
