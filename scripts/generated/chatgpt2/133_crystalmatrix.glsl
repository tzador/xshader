vec4 f() {
  vec2 u = p * 4. - 2.;
  float r = length(u);
  float c1 = 0.;
  for(int i = 0; i < 4; i++) {
    float a = float(i) * 3.14159 / 2. + t * .314;
    vec2 v = u * mat2(C(a), S(a), -S(a), C(a));
    vec2 g = abs(fract(v * (1.5 + float(i) * .2)) - vec2(.5));
    c1 += exp(-max(g.x, g.y) * 6.);
  }
  float c2 = 0.;
  for(int i = 0; i < 3; i++) {
    vec2 v = abs(fract(u * mat2(1, 1, -1, 1) * (1. + float(i) * .4)) - vec2(.5));
    c2 += exp(-length(v) * 7.);
  }
  float c3 = exp(-abs(r - .8 + .1 * S(t * .628)) * 8.);
  vec3 col = mix(vec3(.2, .7, 1.), vec3(.9, .3, .8), c1) * c1 + mix(vec3(.1, .6, .9), vec3(.8, .2, .7), c2) * c2 + vec3(.6, .4, 1.) * c3;
  return vec4(col * exp(-r * 1.4), 1.);
}
