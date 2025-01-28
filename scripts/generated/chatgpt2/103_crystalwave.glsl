vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) * 4. + r * 3.;
  float w = abs(mod(a - t * .628, 2.) - 1.);
  return vec4(mix(vec3(.2, .8, 1.), vec3(.8, .2, 1.), .1 / w) * exp(-r * 2.), 1.);
}
