vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);
  vec2 n = normalize(u + .001);
  float l = 0.;
  for(int i = 0; i < 4; i++) {
    vec2 d = vec2(S(t * .628 + i * 2.), C(t * .628 + i * 2.)) * .7;
    l += pow(max(0., dot(n, normalize(d - u))), 16.);
  }
  float m = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = fract(u * (1. + float(i) * .2) - vec2(t * .2)) - .5;
    m += smoothstep(.1, .0, length(v));
  }
  vec3 col = mix(vec3(.5, .5, .6), vec3(.9, .9, 1.), l) + vec3(.6, .7, .8) * m;
  return vec4(col * exp(-r * 1.2), 1.);
}
