float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 quantumWave(vec2 uv, vec2 center, float frequency, float amplitude) {
  vec2 d = uv - center;
  float dist = length(d);

  // Create wave pattern
  float wave = S(dist * frequency - t * 2.0);

  // Create probability field
  float probability = exp(-dist * 4.0) * amplitude;

  // Combine wave and probability
  return d * wave * probability;
}

float particle(vec2 uv, vec2 pos, float size) {
  float dist = length(uv - pos);
  return exp(-dist * size);
}

vec2 fieldDistortion(vec2 uv, vec2 mousePos) {
  vec2 d = uv - mousePos;
  float dist = length(d);

  // Create quantum tunneling effect
  float tunnel = exp(-dist * 5.0);
  float angle = atan(d.y, d.x) + t;

  return vec2(C(angle), S(angle)) * tunnel * 0.2;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Apply quantum field distortion
  vec2 distortion = fieldDistortion(uv, mousePos);
  uv += distortion;

  // Create wave function
  vec2 waveOffset = vec2(0.0);

  // Add multiple wave sources
  for(float i = 0.0; i < 6.0; i++) {
    float angle = i * Q / 6.0 + t * 0.2;
    vec2 center = vec2(C(angle), S(angle)) * 0.5;

    // Add mouse interaction
    center = mix(center, mousePos, 0.3);

    waveOffset += quantumWave(uv, center, 10.0 + i, 0.2);
  }

  // Create particle field
  float particles = 0.0;
  for(float i = 0.0; i < 20.0; i++) {
    float t_offset = t + i * 1234.5678;

    // Create quantum particle positions
    vec2 pos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 2.0 - 1.0;

    // Add wave-particle interaction
    pos += waveOffset * 0.2;

    // Add mouse attraction
    vec2 toMouse = mousePos - pos;
    pos += normalize(toMouse) * exp(-length(toMouse) * 2.0) * 0.1;

    particles += particle(uv, pos, 20.0);
  }

  // Create colors based on quantum state
  vec3 waveColor = vec3(0.2, 0.4, 0.8);
  vec3 particleColor = vec3(0.8, 0.3, 0.2);
  vec3 interferenceColor = vec3(0.3, 0.8, 0.2);

  // Calculate wave intensity
  float waveIntensity = length(waveOffset);

  // Create interference pattern
  float interference = S(dot(waveOffset, uv) * 10.0 + t);

  // Combine everything
  vec3 color = waveColor * waveIntensity +
    particleColor * particles +
    interferenceColor * interference;

  // Add quantum uncertainty noise
  color *= 0.8 + 0.2 * hash(uv + t);

  // Add mouse interaction glow
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += vec3(0.5, 0.7, 1.0) * mouseGlow;

  // Add uncertainty principle visualization
  float uncertainty = length(waveOffset) * particles;
  color += vec3(1.0, 0.5, 0.0) * uncertainty * 0.5;

  return vec4(color, 1.0);
}
