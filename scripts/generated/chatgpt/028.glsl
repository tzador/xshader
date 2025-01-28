float plasma(vec2 uv) {
  float v1 = S((uv.x + uv.y) * 5.0 + t);
  float v2 = S((uv.x - uv.y) * 5.0 - t * 1.5);
  float v3 = S(length(uv + vec2(S(t * 0.7), C(t * 0.6))) * 6.0);
  float v4 = S(length(uv + vec2(C(t * 0.3), S(t * 0.4))) * 6.0);

  return (v1 + v2 + v3 + v4) * 0.25;
}

vec3 palette(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.263, 0.416, 0.557);

  return a + b * C(Q * (c * t + d));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create base plasma pattern
  float pattern = plasma(uv);

  // Add movement
  pattern += plasma(uv * 2.0 + vec2(S(t), C(t)) * 0.5) * 0.5;
  pattern += plasma(uv * 4.0 - vec2(C(t * 0.7), S(t * 0.8)) * 0.25) * 0.25;

  // Normalize pattern
  pattern = pattern * 0.5 + 0.5;

  // Create color
  vec3 color = palette(pattern + t * 0.1);

  // Add glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.2, 0.1, 0.3) * glow;

  // Add color pulsing
  color *= 0.8 + 0.2 * S(t * 2.0);

  // Add subtle noise
  float noise = fract(S(uv.x * 100.0 + uv.y * 50.0 + t) * 43758.5453);
  color *= 0.95 + 0.05 * noise;

  return vec4(color, 1.0);
}
