vec4 f() {
  vec2 u = p * 4. - 2.;
  float d = 0., a = 1.;
  for(int i = 0; i < 5; i++) {
    vec2 v = u * a + vec2(t * .1 * a);
    float c = 0.;
    for(int j = 0; j < 3; j++) {
      vec2 w = v + vec2(S(float(j) * 2.), C(float(j) * 2.)) * .5;
      vec2 g = fract(w) - .5;
      vec2 id = floor(w);
      c += smoothstep(.2, .0, length(g - vec2(S(id.x + id.y + t), C(id.y - id.x + t)) * .4));
    }
    d += c * a;
    a *= .6;
  }
  vec3 col = mix(vec3(.6, .7, .9), vec3(.9, .95, 1.), d) + vec3(.1) * S(d * 2. - t);
  return vec4(col, 1.);
}
