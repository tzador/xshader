/*
Fractal Dimension Warper
Advanced shader demonstrating:
- Recursive fractal patterns with dimensional folding
- Non-linear space distortions using complex mapping
- Quantum tunneling effects through dimensional barriers
- Self-replicating structures with feedback
- Time-based metamorphosis of fractal space
Creates a mesmerizing visualization of higher-dimensional space folding
*/

vec4 f() {
    // Initialize coordinate system with complex mapping
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  vec2 z = uv;

    // Fractal iteration variables
  float fractal = 0.0;
  vec2 c = vec2(cos(t * 0.5), sin(t * 0.3)) * 0.5;

    // Main fractal iteration loop
  for(int i = 0; i < 8; i++) {
        // Complex number operations for fractal
    float r = length(z);
    float theta = atan(z.y, z.x) * 2.0;

        // Non-linear space transformation
    z = vec2(pow(r, 1.5) * cos(theta) + c.x, pow(r, 1.5) * sin(theta) + c.y);

        // Dimensional folding
    z *= mat2(cos(r), -sin(r), sin(r), cos(r));

        // Accumulate fractal value with quantum effects
    fractal += exp(-length(z) * 0.5) *
      (1.0 + 0.5 * sin(length(z) * 8.0 - t));
  }

    // Secondary dimensional warping
  float warp = 0.0;
  for(int i = 0; i < 4; i++) {
    float angle = float(i) * 1.57079632679 + t;
    vec2 offset = vec2(cos(angle), sin(angle)) * 0.5;
    vec2 p = uv - offset;
    float r = length(p);
    float theta = atan(p.y, p.x);

        // Add dimensional distortion
    warp += exp(-r * 3.0) *
      sin(r * 10.0 + theta * 3.0 - t);
  }

    // Quantum tunneling effect
  float tunnel = 0.0;
  for(int i = 0; i < 3; i++) {
    float phase = float(i) * 2.09439510239;
    vec2 p = vec2(cos(t * 1.5 + phase), sin(t * 1.5 + phase)) * 0.7;
    tunnel += exp(-length(uv - p) * 4.0) *
      sin(length(uv - p) * 15.0 - t);
  }

    // Combine all effects with spectral colors
  vec3 fractalColor = mix(vec3(0.1, 0.4, 1.0), vec3(0.9, 0.1, 0.8), fractal) * fractal;

  vec3 warpColor = mix(vec3(0.2, 0.8, 0.5), vec3(1.0, 0.3, 0.1), warp) * warp;

  vec3 tunnelColor = vec3(0.7, 0.3, 1.0) * tunnel;

    // Final composition with dimensional depth
  float depth = exp(-dist * 0.5) *
    (1.0 + 0.2 * sin(dist * 5.0 - t));

  return vec4((fractalColor + warpColor + tunnelColor) * depth, 1.0);
}
