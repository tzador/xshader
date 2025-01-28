/*
Smoke Effect
Creates a minimal smoke simulation with
turbulent flow and diffusion.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  float smoke = 0.0;

    // Create smoke layers
  for(int i = 0; i < 4; i++) {
    float layer = float(i) * 0.25;

        // Turbulent flow
    vec2 offset = vec2(sin(t + layer * 5.0) * 0.2, t * 0.5 + sin(t * 0.5 + layer) * 0.1);

        // Distort coordinates
    vec2 uv2 = uv + offset;
    float angle = atan(uv2.y, uv2.x);
    float radius = length(uv2);

        // Create smoke pattern
    float pattern = sin(angle * 2.0 + t + layer) * 0.5 + 0.5;
    pattern *= exp(-radius * radius * 2.0);

    smoke += pattern * (1.0 - layer * 0.5);
  }

    // Add turbulence
  smoke *= 1.0 + 0.2 * sin(uv.x * 10.0 + t);
  smoke *= 1.0 + 0.2 * sin(uv.y * 8.0 - t);

    // Create smoke color
  vec3 color = mix(vec3(0.2),            // Dark smoke
  vec3(0.8, 0.8, 0.9),  // Light smoke
  smoke);

  return vec4(color, 1.0);
}
