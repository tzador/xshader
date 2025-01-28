/*
Circuit Board
Generates an animated circuit board pattern with
signal pulses traveling through the paths.
*/

vec4 f() {
  vec2 uv = p * 12.0;  // Grid scale
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;

    // Generate circuit paths
  float rand = fract(sin(dot(id, vec2(127.1, 311.7))) * 43758.5453);

    // Create paths based on random value
  float path_h = step(0.8, rand);
  float path_v = step(0.6, rand) * (1.0 - path_h);

    // Draw paths
  float line_h = smoothstep(0.1, 0.05, abs(gv.y));
  float line_v = smoothstep(0.1, 0.05, abs(gv.x));
  float paths = max(line_h * path_h, line_v * path_v);

    // Animate signals
  float signal_h = sin(t * 2.0 + id.x * 0.5);
  float signal_v = cos(t * 2.0 + id.y * 0.5);
  float signal = max(signal_h * path_h, signal_v * path_v) * 0.5 + 0.5;

    // Combine with colors
  vec3 path_color = vec3(0.2, 0.8, 0.2);  // Green paths
  vec3 bg_color = vec3(0.1);              // Dark background
  vec3 color = mix(bg_color, path_color * (0.5 + 0.5 * signal), paths);

  return vec4(color, 1.0);
}
