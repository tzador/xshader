/*
Minimal Fluid
Creates a simplified fluid simulation with
vortex-like behavior and flow patterns.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  float flow = 0.0;

    // Create vortices
  for(int i = 0; i < 4; i++) {
    float angle = float(i) * 1.5708;
    vec2 center = vec2(cos(angle + t * 0.5), sin(angle + t * 0.7));

        // Calculate flow field
    vec2 rel = uv - center;
    float dist = length(rel);
    vec2 dir = vec2(rel.y, -rel.x) / (dist + 0.1);

        // Add vortex contribution
    flow += dot(dir, normalize(uv)) / (dist + 1.0);
  }

    // Create color from flow
  vec3 color = vec3(0.5 + 0.5 * sin(flow * 2.0 + t), 0.5 + 0.5 * sin(flow * 2.0 + t + 2.094), 0.5 + 0.5 * sin(flow * 2.0 + t + 4.189));

  return vec4(color, 1.0);
}
