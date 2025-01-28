float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 complexMul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

float quantumState(vec2 pos, float time) {
  vec2 state = vec2(0.0);

  // Create multiple wave sources
  for(float i = 0.0; i < 5.0; i++) {
    float angle = i * Q / 5.0 + time * 0.2;
    vec2 source = vec2(C(angle), S(angle)) * 2.0;

    // Calculate wave function
    float dist = length(pos - source);
    float phase = dist * 10.0 - time * 5.0;
    vec2 wave = vec2(C(phase), S(phase)) / (1.0 + dist);

    // Add quantum uncertainty
    float uncertainty = hash(pos + i);
    wave *= 1.0 + uncertainty * 0.2;

    state += wave;
  }

  // Add mouse interaction as an observer
  vec2 mousePos = m * 2.0 - 1.0;
  float observation = exp(-length(pos - mousePos) * 2.0);
  state *= 1.0 - observation * 0.5;

  return length(state);
}

float interferencePattern(vec2 pos, float time) {
  float interference = 0.0;

  // Create interference from multiple quantum states
  for(float dx = -1.0; dx <= 1.0; dx += 0.5) {
    for(float dy = -1.0; dy <= 1.0; dy += 0.5) {
      vec2 offset = vec2(dx, dy);
      float state = quantumState(pos + offset * 0.1, time);
      interference += state;
    }
  }

  return interference * 0.1;
}

vec3 quantumColor(float state, vec2 pos) {
  // Create quantum-inspired color palette
  vec3 col1 = vec3(0.0, 0.5, 1.0);  // Blue
  vec3 col2 = vec3(1.0, 0.0, 0.8);  // Magenta
  vec3 col3 = vec3(0.0, 1.0, 0.5);  // Green

  float f = fract(state * 3.0 + length(pos) * 0.1);
  float t1 = smoothstep(0.0, 0.5, f);
  float t2 = smoothstep(0.5, 1.0, f);

  return mix(mix(col1, col2, t1), col3, t2);
}

float waveCollapse(vec2 pos, float time) {
  // Create wave function collapse effect
  float collapse = 0.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Collapse happens near mouse position
  float dist = length(pos - mousePos);
  float probability = exp(-dist * 3.0);

  // Add time variation
  float temporal = S(time * 5.0 + hash(pos) * 10.0);

  return probability * temporal;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Calculate base quantum state
  float state = quantumState(uv, t);

  // Add interference pattern
  float interference = interferencePattern(uv, t);
  state += interference;

  // Calculate wave function collapse
  float collapse = waveCollapse(uv, t);

  // Create base color from quantum state
  vec3 color = quantumColor(state, uv);

  // Add collapse effect
  vec3 collapseColor = vec3(1.0, 0.8, 0.5);
  color = mix(color, collapseColor, collapse);

  // Add quantum uncertainty noise
  float noise = hash(uv + t) * 0.1;
  color *= 0.9 + noise;

  // Add edge glow
  float edge = abs(state - interferencePattern(uv + 0.01, t));
  color += vec3(0.5, 0.8, 1.0) * edge * 2.0;

  // Add background glow
  float glow = exp(-length(uv) * 1.5);
  color += vec3(0.0, 0.2, 0.4) * glow;

  // Add time-based pulsing
  color *= 0.8 + 0.2 * S(t * 2.0);

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
