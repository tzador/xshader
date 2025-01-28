vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Convert to polar coordinates
  float radius = length(uv);
  float angle = atan(uv.y, uv.x);

  // Create spiral pattern
  float spiral = angle + radius * (6.0 + 4.0 * m.x) - t * 2.0;

  // Add multiple interweaving spirals
  float pattern = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float phase = i * Q / 3.0;
    pattern += 0.3 * (0.5 + 0.5 * S(spiral * 3.0 + phase));
  }

  // Add radial pulse
  pattern *= 0.5 + 0.5 * S(radius * 10.0 - t * 3.0);

  // Color mapping with rotation
  vec3 color = vec3(0.5 + 0.5 * S(pattern * P + t), 0.5 + 0.5 * S(pattern * P + t + Q / 3.0), 0.5 + 0.5 * S(pattern * P + t + Q * 2.0 / 3.0));

  // Fade edges
  float edge = smoothstep(1.0, 0.8, radius);

  return vec4(color * edge, 1.0);
}
