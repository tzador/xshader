vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);
  float segments = 6.0;
  angle = mod(angle, Q / segments) - P / segments;
  uv = vec2(C(angle), S(angle)) * radius;
  vec3 color = vec3(0.5 + 0.5 * C(uv.x * 10.0 + t), 0.5 + 0.5 * S(uv.y * 10.0 + t), 0.5 + 0.5 * S(radius * 10.0 - t));
  return vec4(color, 1.0);
}
