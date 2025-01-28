vec4 f() {
  vec2 u = p * 2. - 1.;
  float r = length(u);
  float s = S(r * 6. - mod(t, 10.) * .628) * S(atan(u.y, u.x) * 4.);
  return vec4((.5 + .5 * C(s * 6. + vec3(0, 2, 4))) * smoothstep(1., .5, r), 1.);
}
