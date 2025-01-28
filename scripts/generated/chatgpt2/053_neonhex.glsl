vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  float a = atan(uv.y, uv.x);
  float r = length(uv);

  float hex = abs(mod(a * 3.0 / P + t, 1.0) - 0.5);
  float glow = 0.02 / abs(r - 0.5 - 0.1 * hex);

  vec3 color = vec3(0.0, 1.0, 0.5) * glow;
  color += vec3(0.5, 0.0, 1.0) * pow(glow, 3.0);

  return vec4(color, 1.0);
}
