/*
Lightning Effect
Creates animated lightning bolts with
branching patterns and glow effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  float lightning = 0.0;

    // Create main bolt
  float main = abs(uv.x) - abs(uv.y) * 0.5;
  main = smoothstep(0.01, 0.0, main);

    // Add branches
  for(int i = 0; i < 4; i++) {
    float offset = float(i) * 0.5;
    float time = t * 2.0 + offset;

        // Branch position
    vec2 branch = uv - vec2(sin(time) * 0.2, offset - 1.0 + cos(time) * 0.1);

        // Create branch pattern
    float pattern = abs(branch.x) - abs(branch.y) * 0.5;
    pattern = smoothstep(0.01, 0.0, pattern);

    lightning += pattern * (1.0 - offset * 0.2);
  }

    // Add electric glow
  lightning += main;
  lightning *= 1.0 + 0.5 * sin(t * 30.0);

    // Create electric color
  vec3 color = mix(vec3(0.2, 0.3, 1.0),  // Blue core
  vec3(0.8, 0.9, 1.0),  // White glow
  lightning);

  return vec4(color, 1.0);
}
