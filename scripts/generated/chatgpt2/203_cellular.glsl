/*
Minimal Cellular Automaton
Creates a continuous cellular automaton with simple rules
that produce complex emergent patterns.
*/

vec4 f() {
  vec2 uv = p * 20.0;  // Grid scale
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;

    // Time-based state
  float t_cell = floor(t * 4.0);

    // Generate cell state from position and time
  float state = fract(sin(dot(id, vec2(127.1, 311.7)) + t_cell) * 43758.5453);

    // Continuous state transition
  float next_state = fract(sin(dot(id, vec2(127.1, 311.7)) + t_cell + 1.0) * 43758.5453);

    // Interpolate between states
  float cell = mix(state, next_state, fract(t * 4.0));

    // Add cell boundary
  float edge = length(gv);
  cell *= smoothstep(0.5, 0.4, edge);

    // Create color pattern
  vec3 color = vec3(cell, cell * (sin(id.x * 0.2 + t) * 0.5 + 0.5), cell * (cos(id.y * 0.2 + t) * 0.5 + 0.5));

  return vec4(color, 1.0);
}
