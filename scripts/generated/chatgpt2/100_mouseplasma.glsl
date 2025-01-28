vec4 f() {
  vec2 u = p * 2. - 1., d = u - m * 2. + 1.;
  float r = length(d);
  float s = S(r * 5. - mod(t, 10.) * .628) * S(atan(d.y, d.x) * 4.);
  return vec4((.5 + .5 * C(s * 8. + vec3(0, 2, 4))) * smoothstep(1., .5, r), 1.);
}
