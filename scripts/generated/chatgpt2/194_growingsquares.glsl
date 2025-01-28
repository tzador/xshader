/*
Growing Squares
Creates a 4x4 grid of squares that grow and shrink based on time.
Each cell contains a square that expands from the corner, creating
a clean geometric pattern.
*/

vec4 f() {
    // Create 4x4 grid of cells
  vec2 uv = fract(p * 4.0);

    // Calculate square size based on time
  float size = fract(t);

    // Create growing square in each cell
  float square = step(uv.x, size) * step(uv.y, size);

    // Add color gradient based on position
  vec3 color = mix(vec3(0.1, 0.2, 0.4),  // Dark blue
  vec3(0.2, 0.4, 0.8),  // Light blue
  square);

  return vec4(color, 1.0);
}
