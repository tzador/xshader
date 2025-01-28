float wave(vec2 pos, vec2 center, float freq, float phase) {
  float dist = length(pos - center);
  return S(dist * freq - phase) / (1.0 + dist * 0.5);
}

float quantumField(vec2 pos) {
  // Create multiple wave sources
  float w1 = wave(pos, vec2(S(t * 0.5), C(t * 0.7)) * 0.5, 10.0, t * 3.0);
  float w2 = wave(pos, vec2(C(t * 0.6), S(t * 0.4)) * 0.5, 12.0, t * 2.0);
  float w3 = wave(pos, vec2(S(t * 0.3), -C(t * 0.5)) * 0.5, 8.0, t * 4.0);

  // Combine waves with interference
  return (w1 + w2 + w3) * 0.3;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Calculate quantum field value
  float field = quantumField(uv);

  // Add probability density visualization
  float probability = exp(-field * field * 4.0);

  // Create complex phase colors
  vec3 color = vec3(0.5 + 0.5 * S(field * P + t), 0.5 + 0.5 * S(field * P + t + P * 0.5), 0.5 + 0.5 * S(field * P + t + P));

  // Mix with probability density
  color = mix(color, vec3(1.0), probability * 0.5);

  // Add subtle glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.1, 0.2, 0.3) * glow;

  return vec4(color, 1.0);
}
