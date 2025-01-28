vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x);
  float e = S(r * 4. - t * .628) + S(a * 6.);
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), r) * e * exp(-r * 3.), 1.);
}
