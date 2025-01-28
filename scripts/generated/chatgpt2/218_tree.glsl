/*
Tree Growth
Creates an animated tree with recursive branching
patterns and leaf effects.
*/

vec4 f() {
  vec2 uv = (p - vec2(0.5, 0.1)) * vec2(2.0, 2.5);
  float tree = 0.0;

    // Create trunk
  float trunk = exp(-pow(uv.x, 2.0) * 16.0) *
    smoothstep(0.0, 0.8, -uv.y);

    // Generate branches
  for(int i = 0; i < 4; i++) {
    float level = float(i) * 0.25;
    float y_pos = -0.8 + level * 1.2;

        // Branch angles
    for(int j = -1; j <= 1; j += 2) {
      float angle = float(j) * (0.3 + level * 0.2);

            // Create branch
      vec2 branch_uv = uv - vec2(0.0, y_pos);
      branch_uv = vec2(branch_uv.x * cos(angle) - branch_uv.y * sin(angle), branch_uv.x * sin(angle) + branch_uv.y * cos(angle));

            // Add branch
      float branch = exp(-pow(branch_uv.x, 2.0) * 32.0) *
        smoothstep(0.0, 0.4, -branch_uv.y) *
        (1.0 - level * 0.5);

      tree += branch;
    }
  }

    // Add leaves
  float leaves = 0.0;
  for(int i = 0; i < 6; i++) {
    float angle = float(i) * 1.047;
    vec2 leaf_pos = vec2(cos(angle + t) * 0.3, sin(angle + t * 0.5) * 0.2 - 0.4);

    leaves += exp(-length(uv - leaf_pos) * 8.0) *
      (0.5 + 0.5 * sin(t * 2.0 + angle));
  }

    // Combine with colors
  vec3 color = mix(vec3(0.4, 0.2, 0.1),  // Brown trunk
  vec3(0.2, 0.8, 0.2),  // Green leaves
  leaves);
  color = mix(vec3(0.0), color, tree + leaves);

  return vec4(color, 1.0);
}
