vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x);
  float s = .1 / abs(r - .3 * S(a * 8. + t * 3.));
  vec3 c = vec3(.1, .3, .8) * s + vec3(.8, .2, 1.) * pow(s, 3.);
  return vec4(c, 1.);
}
