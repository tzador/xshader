/*
Digital Rain
Creates a matrix-style digital rain effect with symbols falling down
the screen. Uses pseudo-random numbers to create variation in the pattern.
*/

vec4 f() {
    // Create grid for digital symbols
  vec2 grid = floor(p * vec2(10.0, 20.0));

    // Generate pseudo-random value for each column
  float random = fract(sin(grid.x * 123.456) * 43758.5453);

    // Create falling motion
  float speed = 0.1;  // Controls fall speed
  float y_offset = grid.y * speed;
  float falling = fract(random - t + y_offset);

    // Create digital rain effect
  float symbol = step(0.5, falling);

    // Add color with brightness falloff
  vec3 color = vec3(0.0, 1.0, 0.0) * symbol * (1.0 - y_offset * 0.1);

  return vec4(color, 1.0);
}
