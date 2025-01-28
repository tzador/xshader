/*
Crystal Wave Effect
Creates an intricate crystalline wave pattern with:
1. Geometric crystal formations
2. Wave interference patterns
3. Dynamic energy flows
4. Phase-shifted overlays
5. Color spectrum transitions
Simulates crystalline structures with wave-like properties
*/

vec4 f() {
    // Initialize coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);

    // Crystal formation pattern
  float crystal = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create rotating crystal planes
    float angle = float(i) * 1.57079632679 + t * 0.5;
    vec2 rotated = vec2(uv.x * cos(angle) - uv.y * sin(angle), uv.x * sin(angle) + uv.y * cos(angle));
    vec2 grid = fract(rotated * (1.0 + float(i) * 0.2)) - 0.5;
        // Add crystal layer
    crystal += exp(-length(grid) * 6.0) *
      (1.0 + 0.5 * sin(length(grid) * 12.0 - t));
  }

    // Wave interference
  float wave = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create overlapping wave patterns
    float phase = float(i) * 2.09439510239;
    vec2 offset = vec2(cos(t + phase), sin(t + phase)) * 0.5;
    wave += exp(-length(uv - offset) * 4.0) *
      sin(length(uv - offset) * 8.0 - t);
  }

    // Energy flow pattern
  float energy = 0.0;
  for(int i = 0; i < 3; i++) {
    float ring = abs(dist - 0.5 - float(i) * 0.3 +
      0.2 * sin(t * 2.0 + float(i)));
    energy += exp(-ring * 6.0) * sin(ring * 15.0 - t);
  }

    // Combine effects with color
  vec3 crystalColor = mix(vec3(0.2, 0.6, 1.0), vec3(0.8, 0.3, 0.9), crystal) * crystal;
  vec3 waveColor = mix(vec3(0.3, 0.5, 1.0), vec3(0.9, 0.4, 0.8), wave) * wave;
  vec3 energyColor = vec3(0.6, 0.4, 1.0) * energy;

    // Final composition
  return vec4((crystalColor + waveColor + energyColor) *
    exp(-dist * 0.6), 1.0);
}
