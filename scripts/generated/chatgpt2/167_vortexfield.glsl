/*
Vortex Field Effect
Creates a dynamic vortex field with:
1. Primary vortex streams
2. Secondary flow patterns
3. Energy distortions
4. Particle systems
5. Interference patterns
Simulates a complex fluid dynamics system
*/

vec4 f() {
    // Setup coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Primary vortex streams
  float vortex = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create rotating flow vectors
    float phase = float(i) * 1.57079632679 + t;
    vec2 dir = vec2(cos(phase), sin(phase));
    vec2 norm = normalize(uv);
        // Calculate flow strength
    float flow = pow(max(0.0, dot(norm, dir)), 3.0) *
      (1.0 + 0.5 * sin(dot(uv, dir) * 4.0 - t));
    vortex += flow;
  }

    // Secondary flow patterns
  float flow = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create rotating distortion
    float phase = t + float(i) * 2.09439510239;
    vec2 rotated = vec2(uv.x * cos(phase) - uv.y * sin(phase), uv.x * sin(phase) + uv.y * cos(phase));
    vec2 cell = fract(rotated * (1.0 + sin(t + float(i)) * 0.2)) - 0.5;
    flow += exp(-length(cell) * 5.0) *
      (1.0 + 0.5 * sin(length(cell) * 8.0 - t));
  }

    // Energy distortions
  float energy = 0.0;
  for(int i = 0; i < 3; i++) {
    float ring = abs(dist - 0.5 - float(i) * 0.2 +
      0.1 * sin(t * 2.0 + float(i)));
    energy += exp(-ring * 6.0) * sin(ring * 20.0 - t);
  }

    // Combine effects with color
  vec3 vortexColor = mix(vec3(0.2, 0.5, 1.0), vec3(0.8, 0.2, 1.0), vortex) * vortex;
  vec3 flowColor = mix(vec3(0.3, 0.6, 0.9), vec3(0.9, 0.3, 0.8), flow) * flow;
  vec3 energyColor = vec3(0.6, 0.4, 1.0) * energy;

    // Final composition with smooth falloff
  return vec4((vortexColor + flowColor + energyColor) *
    smoothstep(1.0, 0.0, dist), 1.0);
}
