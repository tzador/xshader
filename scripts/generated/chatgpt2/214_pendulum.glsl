/*
Double Pendulum
Creates a visualization of chaotic double pendulum
motion with trailing effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  float trail = 0.0;

    // Pendulum parameters
  float l1 = 0.4;  // Length of first arm
  float l2 = 0.3;  // Length of second arm

    // Calculate pendulum positions
  float a1 = t * 2.0;
  float a2 = t * 3.0;

  vec2 p1 = vec2(sin(a1) * l1, -cos(a1) * l1);

  vec2 p2 = p1 + vec2(sin(a2) * l2, -cos(a2) * l2);

    // Draw pendulum arms
  float arms = min(length(uv - p1 * 0.5), length(uv - p2 * 0.5));
  arms = smoothstep(0.02, 0.01, arms);

    // Create trailing effect
  for(int i = 0; i < 8; i++) {
    float past = float(i) * 0.1;
    vec2 pos = p2 * 0.5 - vec2(sin(a2 - past) * 0.1, cos(a2 - past) * 0.1);
    trail += smoothstep(0.02, 0.0, length(uv - pos)) *
      (1.0 - past * 2.0);
  }

    // Combine with colors
  vec3 color = mix(vec3(0.2, 0.4, 0.8),  // Blue trail
  vec3(1.0),            // White pendulum
  arms);
  color += vec3(0.1, 0.2, 0.4) * trail;

  return vec4(color, 1.0);
}
