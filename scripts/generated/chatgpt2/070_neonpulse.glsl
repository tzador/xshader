vec4 f() {
  vec2 u = p * 2. - 1.;
  float d = abs(sin(atan(u.y, u.x) * 3.) + length(u) - .5);
  float g = .05 / d * S(length(u) * 4. - t);
  return vec4(mix(vec3(.8, .2, 1.), vec3(.2, .8, 1.), g) * g, 1.);
}
