float random(vec2 pos) {
  return fract(S(dot(pos, vec2(127.1, 311.7))) * 43758.5453);
}

float crystal(vec2 uv, float time) {
  uv *= 8.0;
  vec2 gv = fract(uv) - 0.5;
  vec2 id = floor(uv);
  float angle = random(id) * Q;

  vec2 rotated = vec2(gv.x * C(angle) - gv.y * S(angle), gv.x * S(angle) + gv.y * C(angle));

  float dist = length(rotated);
  float growth = smoothstep(0.3, 0.0, dist + 0.1 * S(time + random(id) * Q));

  growth += 0.2 * S(20.0 * dist - time * 2.0);
  growth = clamp(growth, 0.0, 1.0);

  return growth;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  float growth = crystal(uv, t * 0.5);

  vec3 color = mix(vec3(0.2, 0.3, 0.8), vec3(1.0, 0.8, 0.2), growth);
  color += 0.1 * S(10.0 * growth + t);
  color *= smoothstep(0.0, 1.0, growth);

  return vec4(color, 1.0);
}
