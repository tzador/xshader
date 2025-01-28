// Differential Growth
// Simulates biological growth patterns with feedback

vec4 f() {
    // Growth parameters
  float growthRate = 0.05;
  float inhibitionRadius = 0.1;
  float maxDensity = 0.8;
  float diffusionRate = 0.001;
  float decay = 0.995;

    // Get current state
  vec4 current = texture2D(b, p);

    // Calculate local density
  float density = 0.0;
  for(float dy = -2.0; dy <= 2.0; dy += 1.0) {
    for(float dx = -2.0; dx <= 2.0; dx += 1.0) {
      vec2 offset = vec2(dx, dy) * inhibitionRadius * 0.2;
      vec4 neighbor = texture2D(b, p + offset);
      float dist = length(offset);
      density += neighbor.r * exp(-dist * dist * 10.0);
    }
  }

    // Calculate growth factor
  float growthFactor = (1.0 - density / maxDensity) * growthRate;

    // Create growth pattern
  vec2 center = vec2(0.5);
  float basePattern = sin(length(p - center) * 20.0 +
    atan(p.y - center.y, p.x - center.x) * 3.0);

    // Add some variation
  float variation = sin(p.x * 30.0 + t) * sin(p.y * 30.0 + t * 1.3) * 0.1;

    // Calculate new growth
  float growth = current.r + (basePattern + variation) * growthFactor;
  growth = clamp(growth, 0.0, 1.0);

    // Add diffusion
  vec2 diffusion = vec2(sin(growth * 6.28318 + t) * diffusionRate, cos(growth * 6.28318 + t) * diffusionRate);

    // Sample previous frame with diffusion
  vec4 previous = texture2D(b, p + diffusion) * decay;

    // Create visualization color
  vec4 growthColor = vec4(growth, growth * 0.8 + 0.2 * sin(t), growth * 0.6 + 0.4 * cos(t * 0.7), 1.0);

    // Add vein-like details
  float veins = smoothstep(0.1, 0.0, abs(sin(growth * 10.0 + t)));
  vec4 veinColor = vec4(1.0, 0.8, 0.6, 1.0) * veins * growth;

    // Combine everything
  return max(max(growthColor, veinColor * 0.3), previous);
}
