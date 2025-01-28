vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  float r = length(uv);
  float a = atan(uv.y, uv.x) * 5.0;

  float ring = abs(r - 0.5 - 0.1 * S(a + t * 3.0));
  float glow = 0.02 / ring;

  vec3 color = vec3(0.2, 0.5, 1.0) * glow;
  color += vec3(1.0, 0.5, 0.2) * pow(glow, 3.0);

  return vec4(color, 1.0);
}
