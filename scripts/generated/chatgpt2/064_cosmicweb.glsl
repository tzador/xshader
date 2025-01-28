vec4 f() {
  vec2 u = p * 3. - 1.5;
  float w = 0.;
  for(int i = 0; i < 3; i++) w += .1 / length(fract(u + vec2(S(t + i), C(t + i))) - .5);
  vec3 c = mix(vec3(.1, .3, .8), vec3(.8, .2, 1.), w);
  return vec4(c * w, 1.);
}
