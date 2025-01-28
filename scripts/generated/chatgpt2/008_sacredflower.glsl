vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float circle(vec2 uv, vec2 center, float radius) {
  return smoothstep(radius + 0.001, radius, length(uv - center));
}

vec3 rainbow(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.0, 0.33, 0.67);

  return a + b * C(Q * (c * t + d));
}

float flowerOfLife(vec2 uv, float scale, float rotation) {
  float pattern = 0.0;
  float radius = 0.15 * scale;

  // Create center circle
  pattern += circle(uv, vec2(0.0), radius);

  // Create surrounding circles
  for(float i = 0.0; i < 6.0; i++) {
    float angle = i * Q / 6.0 + rotation;
    vec2 center = vec2(C(angle), S(angle)) * radius * 2.0;
    pattern += circle(uv, center, radius);

    // Add second layer
    for(float j = 0.0; j < 6.0; j++) {
      float angle2 = j * Q / 6.0 + rotation;
      vec2 center2 = center + vec2(C(angle2), S(angle2)) * radius * 2.0;
      pattern += circle(uv, center2, radius);
    }
  }

  return pattern;
}

float vesica(vec2 uv, float angle, float scale) {
  uv = rotate(uv, angle);
  vec2 offset = vec2(0.1, 0.0) * scale;
  return min(circle(uv, offset, 0.2 * scale), circle(uv, -offset, 0.2 * scale));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create multiple layers of rotating patterns
  float pattern = 0.0;

  // Flower of Life pattern
  float baseRotation = t * 0.2;
  float scale = 1.0 + 0.1 * S(t);
  pattern += flowerOfLife(uv, scale, baseRotation);

  // Add vesica piscis patterns
  for(float i = 0.0; i < 6.0; i++) {
    float angle = i * Q / 6.0 + t * 0.3;
    pattern += vesica(uv, angle, 1.2) * 0.5;
  }

  // Normalize pattern
  pattern = clamp(pattern, 0.0, 1.0);

  // Create rainbow colors
  vec3 color = rainbow(pattern + t * 0.1);

  // Add rotating color variation
  vec2 rotUV = rotate(uv, t * 0.5);
  color *= 0.8 + 0.2 * vec3(S(rotUV.x * 2.0), S(rotUV.y * 2.0), S(length(rotUV) * 2.0));

  // Add glow
  float glow = pattern * 0.5;
  color += vec3(1.0) * glow;

  // Add subtle pulsing
  color *= 0.8 + 0.2 * S(t * 2.0);

  // Add center highlight
  float center = exp(-length(uv) * 5.0);
  color += vec3(1.0) * center;

  return vec4(color, 1.0);
}
