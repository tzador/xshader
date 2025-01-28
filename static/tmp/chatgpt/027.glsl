vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float tunnel(vec2 p, float scale) {
  float angle = atan(p.y, p.x);
  float dist = length(p);

  // Create tunnel pattern
  float pattern = angle * 8.0 + 1.0 / dist + t * 2.0;
  pattern = mod(pattern, Q);
  pattern = A(pattern - P);

  // Add distortion
  pattern += S(dist * 5.0 - t * 3.0) * 0.2;

  return smoothstep(0.5, 0.0, pattern * scale);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create warped space
  float dist = length(uv);
  float warp = 1.0 + dist * 2.0;
  vec2 warped = uv * warp;

  // Rotate space
  float rot = t * 0.2 + dist * 2.0;
  warped = rotate(warped, rot);

  // Create multiple tunnel layers
  vec3 color = vec3(0.0);
  for(float i = 0.0; i < 3.0; i++) {
    float scale = 1.0 + i * 0.5;
    float phase = i * P / 3.0;
    vec2 offset = vec2(S(t + phase), C(t * 1.5 + phase)) * 0.2;

    float pattern = tunnel(warped + offset, scale);

    // Create psychedelic colors
    vec3 layerColor = vec3(0.5 + 0.5 * S(pattern * 5.0 + t + i), 0.5 + 0.5 * S(pattern * 5.0 + t + i + Q / 3.0), 0.5 + 0.5 * S(pattern * 5.0 + t + i + Q * 2.0 / 3.0));

    color += layerColor * pattern * (1.0 - i * 0.2);
  }

  // Add pulsing glow
  float glow = exp(-dist * 3.0);
  color += vec3(0.2, 0.1, 0.3) * glow * (0.5 + 0.5 * S(t * 3.0));

  // Add color cycling
  color *= 0.8 + 0.2 * vec3(S(t), S(t + Q / 3.0), S(t + Q * 2.0 / 3.0));

  return vec4(color, 1.0);
}
