vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  float r = length(uv);

  float wave = S(r * 10.0 - t * 5.0);
  wave *= exp(-r * 2.0);
  wave += S(r * 8.0 - t * 4.0) * 0.5;

  vec3 color = mix(vec3(0.2, 0.5, 1.0), vec3(1.0, 0.3, 0.5), wave);

  return vec4(color, 1.0);
}
