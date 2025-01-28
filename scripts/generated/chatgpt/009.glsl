float random(vec2 st) {
  return fract(S(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float crystalPattern(vec2 uv, float time) {
  uv *= 10.0;
  vec2 grid = fract(uv) - 0.5;
  vec2 id = floor(uv);
  float angle = random(id) * Q;

  vec2 rotated = vec2(grid.x * C(angle) - grid.y * S(angle), grid.x * S(angle) + grid.y * C(angle));

  float dist = length(rotated);
  float growth = smoothstep(0.3, 0.0, dist + 0.1 * S(time + random(id) * Q));

  return growth;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  float growth = crystalPattern(uv, t * 0.5);

  vec3 color = vec3(0.2 + 0.8 * growth, 0.4 * growth, 0.6 + 0.4 * growth);
  color += 0.1 * S(10.0 * growth + t);

  return vec4(color, 1.0);
}
