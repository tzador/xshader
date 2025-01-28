vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float polygon(vec2 p, float sides, float size) {
  float angle = atan(p.y, p.x);
  float segment = Q / sides;
  angle = mod(angle, segment) - segment * 0.5;
  vec2 rotated = length(p) * vec2(C(angle), S(angle));
  return smoothstep(size + 0.01, size, rotated.x);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create rotating coordinate systems
  float time = t * 0.5;
  vec2 uv1 = rotate(uv, time);
  vec2 uv2 = rotate(uv, -time * 0.7);
  vec2 uv3 = rotate(uv, time * 0.3);

  // Create multiple layers of polygons
  float shape1 = polygon(uv1, 6.0, 0.4);
  float shape2 = polygon(uv2, 3.0, 0.6);
  float shape3 = polygon(uv3, 5.0, 0.5);

  // Create color layers
  vec3 color1 = vec3(0.8, 0.2, 0.3) * shape1;
  vec3 color2 = vec3(0.2, 0.8, 0.3) * shape2;
  vec3 color3 = vec3(0.3, 0.2, 0.8) * shape3;

  // Combine layers with different blend modes
  vec3 finalColor = color1 + color2 * (1.0 - color1) + color3 * (1.0 - max(color1, color2));

  // Add shimmer effect
  finalColor *= 1.0 + 0.2 * S(length(uv) * 10.0 - time * 3.0);

  // Add center glow
  float glow = exp(-length(uv) * 3.0);
  finalColor += vec3(1.0) * glow;

  return vec4(finalColor, 1.0);
}
