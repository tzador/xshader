vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float a = atan(u.y, u.x) + S(r * 3. - t);
  float e = .1 / abs(sin(a * 3. + r * 5. - t * 2.));
  return vec4(vec3(.2, .7, 1.) * e * exp(-r * 2.), 1.);
}
