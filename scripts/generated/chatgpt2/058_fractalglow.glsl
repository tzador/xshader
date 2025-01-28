vec4 f() {
  vec2 u = p * 2. - 1.;
  vec2 z = u;
  float g = 0.;
  for(int i = 0; i < 8; i++) {
    z = vec2(z.x * z.x - z.y * z.y, 2. * z.x * z.y) + u;
    g += .1 / length(z);
  }
  return vec4(vec3(.2, .5, 1.) * g, 1.);
}
