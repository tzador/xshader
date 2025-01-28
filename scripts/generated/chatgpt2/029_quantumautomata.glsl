float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 complexMul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

float getCell(vec2 pos, float time) {
  vec2 id = floor(pos);

  // Initialize quantum state based on position
  vec2 state = vec2(hash(id), hash(id + 1234.5));
  float phase = time * (hash(id + 5678.9) * 2.0 - 1.0);

  // Apply quantum rotation
  state = complexMul(state, vec2(C(phase), S(phase)));

  // Get neighboring states
  float neighbors = 0.0;
  for(float dx = -1.0; dx <= 1.0; dx++) {
    for(float dy = -1.0; dy <= 1.0; dy++) {
      if(dx == 0.0 && dy == 0.0)
        continue;

      vec2 nid = id + vec2(dx, dy);
      vec2 nstate = vec2(hash(nid), hash(nid + 1234.5));
      float nphase = time * (hash(nid + 5678.9) * 2.0 - 1.0);
      nstate = complexMul(nstate, vec2(C(nphase), S(nphase)));

      neighbors += length(nstate);
    }
  }

  // Apply quantum rules
  float collapse = step(0.5, length(state));
  float birth = step(2.3, neighbors) * step(neighbors, 3.3);
  float survival = step(1.8, neighbors) * step(neighbors, 3.2);

  return mix(birth, survival, collapse);
}

vec2 rotate2D(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec3 quantumColor(float value, vec2 pos) {
  // Create quantum-inspired color palette
  vec3 col1 = vec3(0.2, 0.4, 0.8);  // Blue
  vec3 col2 = vec3(0.8, 0.2, 0.8);  // Purple
  vec3 col3 = vec3(0.2, 0.8, 0.8);  // Cyan

  float f = fract(value * 3.0 + length(pos) * 0.1);
  float t1 = smoothstep(0.0, 0.5, f);
  float t2 = smoothstep(0.5, 1.0, f);

  return mix(mix(col1, col2, t1), col3, t2);
}

float interferencePattern(vec2 pos, float time) {
  float pattern = 0.0;

  // Create multiple wave sources
  for(float i = 0.0; i < 3.0; i++) {
    float angle = i * Q / 3.0 + time * 0.2;
    vec2 source = vec2(C(angle), S(angle)) * 2.0;
    float wave = S(length(pos - source) * 5.0 - time * 5.0);
    pattern += wave;
  }

  return pattern * 0.3;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create zoom and rotation based on mouse
  float zoom = 10.0 + mousePos.y * 5.0;
  float rotation = t * 0.1 + mousePos.x * Q;

  // Transform space
  vec2 pos = rotate2D(uv * zoom, rotation);

  // Get cellular automata state
  float cell = getCell(pos, t);

  // Add interference pattern
  float interference = interferencePattern(uv, t);

  // Calculate quantum probability field
  float probability = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    vec2 offset = vec2(hash(vec2(i, t)), hash(vec2(t, i))) * 2.0 - 1.0;

    float p = getCell(pos + offset, t);
    probability += p * exp(-length(offset));
  }
  probability *= 0.3;

  // Create base color from cell state
  vec3 color = quantumColor(cell + interference, uv);

  // Add probability field glow
  vec3 glowColor = quantumColor(probability - t * 0.1, uv);
  color += glowColor * probability;

  // Add wave function collapse effects
  float collapse = step(0.98, hash(floor(pos)));
  color = mix(color, vec3(1.0), collapse * (0.5 + 0.5 * S(t * 10.0)));

  // Add quantum tunneling effect
  float tunnel = exp(-length(uv - mousePos) * 5.0);
  color += quantumColor(tunnel + t * 0.2, uv) * tunnel;

  // Add edge enhancement
  vec2 e = vec2(1.0 / zoom, 0.0);
  float edge = abs(getCell(pos + e.xy, t) - getCell(pos - e.xy, t)) +
    abs(getCell(pos + e.yx, t) - getCell(pos - e.yx, t));
  color += vec3(1.0) * edge * 0.5;

  // Add subtle pulsing
  color *= 0.8 + 0.2 * S(t * 2.0);

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
