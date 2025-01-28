/*
Binary Counter
Creates an 8x8 grid where each cell represents a bit in a 64-bit counter.
The pattern cycles through binary numbers, creating a visual representation
of binary counting.
*/

vec4 f() {
    // Create 8x8 grid coordinates
  vec2 grid = floor(p * 8.0);

    // Calculate bit position in 64-bit sequence
  float bit_position = grid.x + grid.y * 8.0;

    // Create binary counter based on time
  float state = mod(floor(t * 2.0) + bit_position, 2.0);

    // Add subtle color variation based on position
  vec3 color = vec3(1.0, 0.9, 0.8) * state;

  return vec4(color, 1.0);
}
