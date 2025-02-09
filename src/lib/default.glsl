vec4 f() {
  vec2 uv = p * 20.0;
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;
  float t_cell = floor(t * 4.0);
  float state = fract(sin(dot(id, vec2(127.1, 311.7)) + t_cell) * 43758.5453);
  float next_state = fract(sin(dot(id, vec2(127.1, 311.7)) + t_cell + 1.0) * 43758.5453);
  float cell = mix(state, next_state, fract(t * 4.0));
  float edge = length(gv);
  cell *= smoothstep(0.5, 0.4, edge);
  vec3 color = vec3(cell, cell * (sin(id.x * 0.2 + t) * 0.5 + 0.5), cell * (cos(id.y * 0.2 + t) * 0.5 + 0.5));
  return vec4(color, 1.0);
}
