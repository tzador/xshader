/*
Procedural Maze
Generates a maze pattern with animated path finding
using minimal distance field techniques.
*/

vec4 f() {
  vec2 uv = p * 16.0;  // Grid size
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;

    // Generate maze walls
  float maze = 0.0;
  vec2 offset = vec2(sin(dot(id, vec2(127.1, 311.7))), sin(dot(id, vec2(269.5, 183.3))));

    // Create corridors
  float corridor_x = step(0.4, abs(gv.x));
  float corridor_y = step(0.4, abs(gv.y));
  float wall = min(corridor_x, corridor_y);

    // Animate pathfinding
  vec2 flow = vec2(sin(t + offset.x * 6.28), cos(t + offset.y * 6.28)) * 0.5;

    // Add flow effect
  float path = length(gv - flow * 0.3);
  path = smoothstep(0.1, 0.0, path);

    // Combine elements
  vec3 color = mix(vec3(0.1),                    // Dark walls
  vec3(0.2, 0.5, 1.0),         // Blue paths
  path * (1.0 - wall)           // Mask with walls
  );

  return vec4(color, 1.0);
}
