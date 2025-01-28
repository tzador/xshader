/*
Sliding Tiles
Creates a grid of tiles that slide horizontally across the screen,
creating a continuous motion pattern with clean geometric edges.
*/

vec4 f() {
    // Create 5x5 grid with horizontal sliding
  vec2 uv = fract(p * 5.0 - vec2(t, 0.0));

    // Create tile edges
  float edge_x = step(0.9, uv.x);
  float edge_y = step(0.9, uv.y);
  float edges = max(edge_x, edge_y);

    // Add alternating rows
  float row = floor(p.y * 5.0);
  float direction = mod(row, 2.0) * 2.0 - 1.0;  // Alternate direction
  uv.x = fract(p.x * 5.0 - t * direction);
  float alt_edges = step(0.9, uv.x) + edge_y;

    // Combine patterns with colors
  vec3 edge_color = vec3(0.9, 0.8, 0.2);    // Yellow
  vec3 tile_color = vec3(0.2, 0.3, 0.4);    // Blue-gray
  vec3 color = mix(tile_color, edge_color, alt_edges);

  return vec4(color, 1.0);
}
