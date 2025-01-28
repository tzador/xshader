vec4 f() {
  vec2 u = p * 3. - 1.5;
  float m = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = abs(fract(u * (1. + float(i))) - .5);
    m += min(v.x, v.y) / (1. + float(i));
  }
  return vec4(mix(vec3(.2, .5, 1.), vec3(.8, .2, 1.), S(m * 5. - t * .628)) * exp(-m * 3.), 1.);
}
