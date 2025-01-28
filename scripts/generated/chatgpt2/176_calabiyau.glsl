/*
Calabi-Yau Manifold Visualization
Advanced mathematical shader demonstrating:
- 6D complex manifold projection to 2D
- Holomorphic volume form representation
- Fiber bundle visualization with dynamic evolution
- Mirror symmetry and complex structure deformation
- Multiple interweaving surfaces with phase transitions

Mathematical concepts:
- Complex manifold mapping
- Kähler potential
- Holomorphic coordinates
- Ricci-flat metrics
- Fiber bundle structure
*/

vec4 f() {
    // Initialize complex coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  vec2 z = uv;

    // Complex structure parameters
  float tau = t * 0.2;
  vec2 modular = vec2(cos(tau), sin(tau));

    // Fiber bundle accumulator
  float fiber = 0.0;
  vec2 w = z;

    // Main fiber bundle iteration
  for(int i = 0; i < 7; i++) {
        // Complex coordinate transformation
    float theta = float(i) * 0.897598959 + t * 0.3;
    vec2 zw = vec2(w.x * cos(theta) - w.y * sin(theta), w.x * sin(theta) + w.y * cos(theta));

        // Holomorphic coordinate mapping
    float r = length(zw);
    float phi = atan(zw.y, zw.x);

        // Kähler potential contribution
    w = vec2(pow(r, 1.5) * cos(phi * 2.0), pow(r, 1.5) * sin(phi * 2.0));

        // Accumulate fiber bundle structure
    fiber += exp(-length(w) * 0.5) *
      (1.0 + 0.5 * sin(length(w) * 6.0 - t));
  }

    // Mirror symmetry deformation
  float mirror = 0.0;
  for(int i = 0; i < 5; i++) {
    float phase = float(i) * 1.25663706144;
    vec2 p = vec2(cos(t + phase) * modular.x, sin(t + phase) * modular.y) * 0.8;

        // Calculate mirror transform
    float d = length(z - p);
    mirror += exp(-d * 3.0) *
      sin(d * 12.0 - t + phase);
  }

    // Complex structure deformation
  float deform = 0.0;
  for(int i = 0; i < 4; i++) {
    vec2 w = z * mat2(cos(t * 0.5), -sin(t * 0.5), sin(t * 0.5), cos(t * 0.5));
    float r = length(w);
    float theta = atan(w.y, w.x) + float(i) * 1.57079632679;

    deform += exp(-r * 2.0) *
      sin(theta * 3.0 + r * 8.0 - t);
  }

    // Combine manifold structures with complex colors
  vec3 fiberColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.1, 0.8), fiber) * fiber;

  vec3 mirrorColor = mix(vec3(0.2, 0.8, 0.5), vec3(0.8, 0.2, 0.4), mirror) * mirror;

  vec3 deformColor = vec3(0.7, 0.3, 1.0) * deform;

    // Final composition with complex phase
  float phase = exp(-dist * 0.4) *
    (1.0 + 0.2 * sin(dist * 5.0 - t));

  return vec4((fiberColor + mirrorColor + deformColor) * phase, 1.0);
}
