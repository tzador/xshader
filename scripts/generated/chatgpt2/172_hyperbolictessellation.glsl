/*
Hyperbolic Tessellation
Advanced shader demonstrating:
- Non-euclidean geometry in hyperbolic space
- Möbius transformations for complex mapping
- Infinite tiling through hyperbolic reflections
- Dynamic symmetry breaking patterns
- Complex phase space visualization
Creates an infinite tessellation in hyperbolic geometry
*/

vec4 f() {
    // Initialize hyperbolic coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);

    // Convert to complex number for Möbius transformations
  vec2 z = uv;
  float r2 = dot(z, z);

    // Hyperbolic distance metric
  float hyp_dist = log((1.0 + dist) / (1.0 - min(dist, 0.99)));

    // Main tessellation pattern
  float pattern = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create hyperbolic rotation
    float angle = float(i) * 1.04719755119 + t * 0.2;
    vec2 w = z;

        // Apply Möbius transformation
    float denom = 1.0 / (1.0 + 2.0 * (w.x * cos(angle) + w.y * sin(angle)) + r2);
    w = vec2((w.x + cos(angle)) * denom, (w.y + sin(angle)) * denom);

        // Generate hyperbolic tiles
    float cell = length(fract(w * (2.0 + sin(t))) - 0.5);
    pattern += exp(-cell * 5.0) *
      (1.0 + 0.5 * sin(cell * 10.0 - hyp_dist * 2.0 - t));
  }

    // Secondary symmetry patterns
  float sym = 0.0;
  for(int i = 0; i < 4; i++) {
    float phase = float(i) * 1.57079632679;
    vec2 p = vec2(cos(t + phase) * hyp_dist, sin(t + phase) * hyp_dist);

        // Add symmetric elements
    float d = length(z - p);
    sym += exp(-d * 3.0) * sin(d * 8.0 - t);
  }

    // Dynamic field distortions
  float field = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create field vectors in hyperbolic space
    float angle = float(i) * 2.09439510239 + t;
    vec2 dir = vec2(cos(angle), sin(angle));

        // Add field contribution
    field += exp(-abs(dot(normalize(z), dir)) * 4.0) *
      sin(hyp_dist * 5.0 - t);
  }

    // Combine effects with hyperbolic color mapping
  vec3 patternColor = mix(vec3(0.1, 0.5, 0.9), vec3(0.9, 0.2, 0.7), pattern) * pattern;

  vec3 symColor = mix(vec3(0.2, 0.7, 0.5), vec3(0.8, 0.3, 0.2), sym) * sym;

  vec3 fieldColor = vec3(0.6, 0.3, 1.0) * field;

    // Final composition with hyperbolic depth
  float depth = 1.0 / (1.0 + hyp_dist * 0.5);

  return vec4((patternColor + symColor + fieldColor) * depth, 1.0);
}
