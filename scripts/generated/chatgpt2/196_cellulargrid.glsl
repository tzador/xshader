/*
Cellular Grid
Creates a grid of cells that activate and deactivate based on
deterministic rules using pseudo-random numbers and time.
*/

vec4 f() {
    // Create 10x10 grid
  vec2 id = floor(p * 10.0);

    // Generate unique value for each cell
  float cell_value = fract(sin(dot(id, vec2(12.9898, 78.233))) * 43758.5453);

    // Create cellular activation pattern
  float threshold = 0.5 + 0.5 * sin(t);  // Oscillating threshold
  float state = step(threshold, cell_value);

    // Add color variation based on cell position
  vec3 active_color = vec3(0.8, 0.2, 0.2);    // Red
  vec3 inactive_color = vec3(0.1, 0.1, 0.1);  // Dark gray
  vec3 color = mix(inactive_color, active_color, state);

  return vec4(color, 1.0);
}
