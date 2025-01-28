/*
Plasma Web Effect
Creates an interconnected plasma network with:
1. Primary plasma streams
2. Web-like connections
3. Energy nodes
4. Field distortions
5. Dynamic color flows
Simulates an organic energy network
*/

vec4 f() {
    // Initialize coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);

    // Primary plasma streams
  float plasma = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create plasma flow points
    float phase = float(i) * 1.25663706144;
    vec2 center = vec2(cos(t * 1.5 + phase), sin(t * 1.5 + phase)) * 0.7;
        // Calculate plasma density
    float d = length(uv - center);
    plasma += exp(-d * 4.0) *
      (1.0 + 0.5 * sin(d * 12.0 - t));
  }

    // Web connections
  float web = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create web pattern
    float angle = float(i) * 1.57079632679 + t * 0.5;
    vec2 rotated = vec2(uv.x * cos(angle) - uv.y * sin(angle), uv.x * sin(angle) + uv.y * cos(angle));
        // Add web strands
    vec2 grid = fract(rotated * (1.5 + sin(t + float(i)) * 0.2)) - 0.5;
    web += exp(-length(grid) * 8.0) *
      (1.0 + 0.5 * sin(length(grid) * 15.0 - t));
  }

    // Energy nodes
  float nodes = 0.0;
  for(int i = 0; i < 3; i++) {
    float ring = abs(dist - 0.6 - float(i) * 0.3 +
      0.15 * sin(t * 2.0 + float(i)));
    nodes += exp(-ring * 7.0) *
      sin(ring * 20.0 - t + float(i));
  }

    // Combine effects with color
  vec3 plasmaColor = mix(vec3(0.2, 0.5, 1.0), vec3(0.8, 0.2, 1.0), plasma) * plasma;
  vec3 webColor = mix(vec3(0.3, 0.6, 0.9), vec3(0.9, 0.3, 0.8), web) * web;
  vec3 nodeColor = vec3(0.6, 0.4, 1.0) * nodes;

    // Final composition
  return vec4((plasmaColor + webColor + nodeColor) *
    exp(-dist * 0.7), 1.0);
}
