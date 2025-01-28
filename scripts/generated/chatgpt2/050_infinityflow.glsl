vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 z = vec2(uv.x, uv.y * 2.0);
  float a = atan(z.y, z.x);

  float d = length(z - vec2(S(a + t), 0.0));
  d = min(d, length(z + vec2(S(a - t), 0.0)));
  float glow = 0.02 / d;

  vec3 color = vec3(0.5, 0.2, 1.0) * glow;
  color *= 1.0 - length(uv) * 0.5;

  return vec4(color, 1.0);
}
