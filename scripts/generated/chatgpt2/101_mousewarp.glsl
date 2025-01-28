vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  vec2 w = u + d * exp(-r * 3.) * .3;
  float g = length(fract(w * 3.) - .5);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), r) * exp(-g * 3.), 1.);
}
