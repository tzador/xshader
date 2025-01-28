float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float getFrequency(float index, vec2 mousePos) {
  // Create interactive frequency based on mouse position and time
  return 0.5 + 0.5 * S(t * (1.0 + index * 0.2) + mousePos.x * 5.0 + index * 0.5);
}

float getAmplitude(float index, vec2 mousePos) {
  // Create interactive amplitude based on mouse position
  return 0.2 + 0.3 * (1.0 - mousePos.y) * S(index * 0.5 + t);
}

float waveform(vec2 uv, float frequency, float amplitude, float phase) {
  // Create base wave
  float wave = S(uv.x * frequency + phase);

  // Add harmonics
  wave += 0.5 * S(uv.x * frequency * 2.0 + phase);
  wave += 0.25 * S(uv.x * frequency * 4.0 + phase);

  return wave * amplitude;
}

float visualizer(vec2 uv, vec2 mousePos) {
  float waves = 0.0;

  // Create multiple wave layers
  for(float i = 0.0; i < 8.0; i++) {
    float freq = getFrequency(i, mousePos);
    float amp = getAmplitude(i, mousePos);
    float phase = t * (2.0 + i * 0.5);

    // Rotate and offset each wave
    vec2 rotatedUV = rotate(uv, i * P / 8.0 + t * 0.1);
    waves += waveform(rotatedUV, freq * 10.0, amp, phase);
  }

  return waves;
}

vec3 spectrum(float value) {
  // Create spectrum colors
  vec3 col1 = vec3(0.2, 0.5, 0.8); // Blue
  vec3 col2 = vec3(0.8, 0.2, 0.5); // Pink
  vec3 col3 = vec3(0.3, 0.8, 0.3); // Green

  float t1 = value * 3.0;
  float t2 = t1 - 1.0;
  float t3 = t2 - 1.0;

  return max(vec3(0.0), col1 * (1.0 - t1) +
    col2 * (1.0 - A(t2)) +
    col3 * (1.0 + t3));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create main wave visualization
  float waves = visualizer(uv, mousePos);

  // Create circular wave pattern
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);
  float circularWave = S(angle * 8.0 + radius * 5.0 - t * 3.0);

  // Combine waves with circular pattern
  float pattern = waves * 0.7 + circularWave * 0.3;

  // Create 3D effect based on mouse position
  vec2 mouseOffset = (uv - mousePos) * 0.5;
  float depth = 0.5 + 0.5 * S(length(mouseOffset) * 5.0 - t);
  pattern *= depth;

  // Create color
  vec3 color = spectrum(pattern);

  // Add frequency bars
  float bars = 0.0;
  for(float i = 0.0; i < 10.0; i++) {
    float x = i / 10.0 * 2.0 - 1.0;
    float freq = getFrequency(i, mousePos);
    float height = freq * 0.5;

    float bar = smoothstep(height, height - 0.1, A(uv.y)) *
      smoothstep(0.05, 0.0, A(uv.x - x));
    bars += bar;
  }

  // Add glow effects
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.2, 0.4, 0.8) * glow;

  // Add mouse interaction glow
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += spectrum(mouseGlow) * mouseGlow;

  // Add frequency bar colors
  color += spectrum(bars) * bars * 0.5;

  // Add subtle noise texture
  color *= 0.8 + 0.2 * hash(uv * 10.0 + t);

  return vec4(color, 1.0);
}
