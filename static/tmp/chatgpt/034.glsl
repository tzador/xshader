float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float getCellState(vec2 pos, float time) {
  vec2 id = floor(pos);
  float state = step(0.5, hash(id));

  // Get neighbor states
  float neighbors = 0.0;
  for(float y = -1.0; y <= 1.0; y++) {
    for(float x = -1.0; x <= 1.0; x++) {
      if(x == 0.0 && y == 0.0)
        continue;
      vec2 offset = vec2(x, y);
      neighbors += step(0.5, hash(id + offset));
    }
  }

  // Conway's Game of Life rules
  float nextState = 0.0;
  if(state > 0.5) {
    // Survival
    nextState = step(1.5, neighbors) * step(neighbors, 3.5);
  } else {
    // Birth
    nextState = step(2.5, neighbors) * step(neighbors, 3.5);
  }

  // Temporal evolution
  float generation = floor(time * 2.0);
  return mix(state, nextState, step(0.5, hash(id + generation)));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv *= 10.0; // Scale for more cells

  // Get cell coordinates
  vec2 cell = floor(uv);
  vec2 frac = fract(uv);

  // Get cell state
  float state = getCellState(uv, t);

  // Create cell pattern
  float pattern = state;

  // Add cell borders
  vec2 smoothFrac = smoothstep(0.0, 0.1, frac) * smoothstep(1.0, 0.9, frac);
  float border = smoothFrac.x * smoothFrac.y;
  pattern *= border;

  // Create colors
  vec3 alive = vec3(0.2, 0.8, 0.4);
  vec3 dead = vec3(0.1, 0.1, 0.2);
  vec3 color = mix(dead, alive, pattern);

  // Add glow
  float glow = 0.0;
  for(float y = -1.0; y <= 1.0; y++) {
    for(float x = -1.0; x <= 1.0; x++) {
      vec2 offset = vec2(x, y);
      float neighborState = getCellState(uv + offset, t);
      glow += neighborState * exp(-length(offset) * 2.0);
    }
  }
  color += vec3(0.1, 0.3, 0.2) * glow;

  // Add subtle animation
  color *= 0.8 + 0.2 * S(t * 2.0 + uv.x + uv.y);

  // Add vignette
  float vignette = 1.0 - length(p);
  color *= vignette;

  return vec4(color, 1.0);
}
