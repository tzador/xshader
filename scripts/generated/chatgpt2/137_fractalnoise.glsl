vec4 f() {
  vec2 u = p * 4. - 2.;
  float n = 0., a = 1.;
  for(int i = 0; i < 4; i++) {
    vec2 v = u * a + vec2(t * .2 * float(i));
    vec2 g = fract(v) - .5;
    vec2 id = floor(v);
    float c = 0.;
    for(int j = 0; j < 4; j++) c += 1. / length(g - vec2(S(id.x * 7. + id.y * 3. + float(j) * 11.), C(id.y * 7. + id.x * 3. + float(j) * 11.)) * .4);
    n += c * a;
    a *= .5;
  }
  vec3 col = mix(vec3(.2, .3, .4), vec3(.7, .8, .9), n * .1) + vec3(.1, .2, .3) * S(n * 3. - t);
  return vec4(col, 1.);
}
