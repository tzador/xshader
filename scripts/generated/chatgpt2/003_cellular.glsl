float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float cell(vec2 uv) {
  vec2 i = floor(uv);
  vec2 f = fract(uv);

  // Get cell state based on surrounding cells
  float state = 0.0;
  for(float y = -1.0; y <= 1.0; y++) {
    for(float x = -1.0; x <= 1.0; x++) {
      vec2 neighbor = vec2(x, y);
      float n = hash(i + neighbor + floor(t * 2.0));
      state += step(0.6, n);
    }
  }

  // Apply cellular automaton rules (similar to Game of Life)
  float alive = step(0.6, hash(i + floor(t * 2.0)));
  float nextState = step(2.9, state) * step(state, 3.1) +
    step(1.9, state) * step(state, 2.1) * alive;

  // Smooth transition between states
  float transition = fract(t * 2.0);
  return mix(alive, nextState, transition);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv *= 5.0; // Scale for more cells

  // Add some movement
  uv += vec2(S(t * 0.5), C(t * 0.4)) * 0.5;

  // Calculate cell state with anti-aliasing
  float state = 0.0;
  const float AA = 2.0;
  for(float y = 0.0; y < AA; y++) {
    for(float x = 0.0; x < AA; x++) {
      vec2 offset = vec2(x, y) / AA * 0.5;
      state += cell(uv + offset);
    }
  }
  state /= (AA * AA);

  // Create base color
  vec3 cellColor = vec3(0.2, 0.6, 1.0);
  vec3 deadColor = vec3(0.1, 0.1, 0.2);

  // Add color variation based on position and time
  cellColor *= 0.8 + 0.2 * vec3(S(uv.x + t), S(uv.y - t), S(length(uv) + t));

  // Mix colors based on state
  vec3 color = mix(deadColor, cellColor, state);

  // Add glow effect
  float glow = 0.0;
  for(float i = 1.0; i < 4.0; i++) {
    float radius = i * 0.5;
    vec2 offset = vec2(S(t * i), C(t * i)) * radius;
    glow += cell(uv + offset) * (1.0 / i);
  }

  color += cellColor * glow * 0.5;

  // Add subtle vignette
  float vignette = 1.0 - length(p * 2.0 - 1.0) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
