vec4 f() {
  vec2 u = p * 4. - 2.;
  float c = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = u;
    for(int j = 0; j < 2; j++) {
      v = vec2(v.x * v.x - v.y * v.y, 2. * v.x * v.y) * .5 + vec2(S(t * .628 + float(i)), C(t * .628 + float(i)));
    }
    c += exp(-length(v) * (2. + float(i)));
  }
  float w = 0.;
  for(int i = 0; i < 4; i++) w += S(dot(u, vec2(S(float(i) * 1.57 + t), C(float(i) * 1.57 + t))) * 3.);
  vec3 col = mix(vec3(.1, .2, .4), vec3(.5, .7, .9), c) + vec3(.2, .4, .6) * w;
  return vec4(col, 1.);
}
