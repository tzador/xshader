vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float s = .5 + .5 * S(r * 8. - t * 3.);
  vec3 c = .5 + .5 * C(s * 8. + vec3(0, 2, 4));
  float g = exp(-pow(r - .5, 2.) * 4.);
  return vec4(c * g + vec3(.8, .2, 1.) * pow(g, 8.), 1.);
}
