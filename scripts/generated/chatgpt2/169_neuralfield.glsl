/*
Neural Field Effect
Creates a dynamic neural network visualization with:
1. Synaptic connections
2. Neural activation patterns
3. Signal propagation
4. Energy pulses
5. Field interactions
Simulates neural network activity patterns
*/

vec4 f() {
    // Setup coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);

    // Synaptic connections
  float synapses = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create neural pathways
    float angle = float(i) * 1.25663706144 + t * 0.5;
    vec2 rotated = vec2(uv.x * cos(angle) - uv.y * sin(angle), uv.x * sin(angle) + uv.y * cos(angle));
    vec2 grid = fract(rotated * (1.2 + sin(t + float(i)) * 0.2)) - 0.5;
        // Add synaptic strength
    synapses += exp(-length(grid) * 6.0) *
      (1.0 + 0.5 * sin(length(grid) * 10.0 - t));
  }

    // Neural activation
  float activation = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create activation centers
    vec2 center = vec2(cos(t * 2.0 + float(i) * 1.57079632679), sin(t * 2.0 + float(i) * 1.57079632679)) * 0.8;
    float d = length(uv - center);
        // Calculate activation strength
    activation += exp(-d * 5.0) *
      (1.0 + 0.5 * sin(d * 15.0 - t));
  }

    // Signal propagation
  float signal = 0.0;
  for(int i = 0; i < 3; i++) {
    float ring = abs(dist - 0.5 - float(i) * 0.25 +
      0.2 * sin(t * 1.5 + float(i)));
    signal += exp(-ring * 8.0) *
      sin(ring * 25.0 - t + float(i));
  }

    // Combine effects with color
  vec3 synapticColor = mix(vec3(0.2, 0.5, 1.0), vec3(0.8, 0.2, 1.0), synapses) * synapses;
  vec3 activeColor = mix(vec3(0.3, 0.6, 0.9), vec3(0.9, 0.3, 0.8), activation) * activation;
  vec3 signalColor = vec3(0.6, 0.4, 1.0) * signal;

    // Final composition with depth
  return vec4((synapticColor + activeColor + signalColor) *
    smoothstep(1.0, 0.0, dist), 1.0);
}
