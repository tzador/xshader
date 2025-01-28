/*
Butterfly Wing
Creates an animated butterfly with symmetric wing
patterns and iridescent colors.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  float wing = 0.0;

    // Mirror coordinates for symmetry
  uv.x = abs(uv.x);

    // Create wing shape
  float angle = sin(t * 2.0) * 0.3;
  vec2 wing_uv = vec2(uv.x * cos(angle) - uv.y * sin(angle), uv.x * sin(angle) + uv.y * cos(angle));

    // Wing outline
  float outline = length(wing_uv - vec2(0.3, 0.0));
  outline = smoothstep(0.6, 0.5, outline);

    // Create wing patterns
  for(int i = 0; i < 4; i++) {
    float radius = float(i) * 0.15;
    vec2 center = vec2(0.3, 0.0) +
      vec2(cos(radius * 8.0), sin(radius * 8.0)) * radius;

        // Add pattern elements
    float pattern = length(wing_uv - center);
    pattern = smoothstep(0.15, 0.0, pattern);
    pattern *= sin(radius * 20.0 + t) * 0.5 + 0.5;

    wing += pattern;
  }

    // Combine with wing shape
  wing *= outline;

    // Create iridescent colors
  vec3 color = vec3(sin(wing * 4.0 + t) * 0.5 + 0.5, sin(wing * 4.0 + t + 2.094) * 0.5 + 0.5, sin(wing * 4.0 + t + 4.189) * 0.5 + 0.5);

  return vec4(color * wing, 1.0);
}
