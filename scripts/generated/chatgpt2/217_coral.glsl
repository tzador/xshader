/*
Coral Growth
Creates a procedural coral growth pattern with
organic branching structures.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  float coral = 0.0;

    // Create growth points
  for(int i = 0; i < 5; i++) {
    float angle = float(i) * 1.257;
    vec2 base = vec2(cos(angle) * 0.2, sin(angle) * 0.2);

        // Generate branches
    for(int j = 0; j < 3; j++) {
      float branch = float(j) * 0.3;
      vec2 offset = vec2(sin(t + angle * 2.0 + branch) * 0.1, cos(t * 0.7 + angle + branch) * 0.1);

            // Create growth pattern
      vec2 pos = base + offset * branch;
      float pattern = exp(-length(uv - pos) * (8.0 - branch * 4.0));

      coral += pattern * (1.0 - branch * 0.2);
    }
  }

    // Add organic variation
  coral *= 1.0 + 0.2 * sin(uv.x * 10.0 + t);
  coral *= 1.0 + 0.2 * sin(uv.y * 8.0 - t);

    // Create coral colors
  vec3 color = mix(vec3(0.8, 0.2, 0.3),  // Pink coral
  vec3(1.0, 0.8, 0.8),  // White tips
  coral);

  return vec4(color, 1.0);
}
