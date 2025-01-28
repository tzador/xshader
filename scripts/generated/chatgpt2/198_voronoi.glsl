/*
Minimal Voronoi
Creates an animated Voronoi diagram with moving cell centers,
using minimal distance calculations for cell boundaries.
*/

vec4 f() {
  vec2 uv = p * 3.0;
  float min_dist = 10.0;
  vec3 cell_color = vec3(0.0);

    // Calculate 4 moving cell centers
  for(int i = 0; i < 4; i++) {
    float angle = float(i) * 1.57079 + t;
    vec2 center = vec2(cos(angle) * 0.3 + 0.5, sin(angle * 0.7) * 0.3 + 0.5) * 3.0;

    float dist = length(uv - center);
    if(dist < min_dist) {
      min_dist = dist;
      cell_color = vec3(sin(angle) * 0.5 + 0.5, cos(angle * 0.7) * 0.5 + 0.5, sin(angle * 1.3) * 0.5 + 0.5);
    }
  }

    // Add cell edges
  float edge = step(0.1, fract(min_dist * 3.0));
  return vec4(mix(cell_color, vec3(1.0), edge), 1.0);
}
