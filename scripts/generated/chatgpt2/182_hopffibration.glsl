/*
Hopf Fibration
Advanced visualization demonstrating:
- S³ to S² mapping visualization
- Fiber bundle structure
- Topological linking
- Great circle fibers
- Stereographic projection

Mathematical concepts:
- Fiber bundles
- Complex projective space
- Quaternion multiplication
- Circle fibration
- Topological invariants
*/

vec4 f() {
    // Initialize S³ coordinates
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Stereographic projection parameters
  float proj_scale = 1.0 / (1.0 + dist * dist);
  vec2 stereo = uv * proj_scale;

    // Primary fiber structure
  float fiber = 0.0;
  for(int i = 0; i < 8; i++) {
        // Create fiber circles
    float phase = float(i) * 0.785398163397;
    vec2 q1 = vec2(cos(phase), sin(phase));
    vec2 q2 = vec2(-sin(phase), cos(phase));

        // Quaternion multiplication
    vec2 w = vec2(stereo.x * q1.x - stereo.y * q1.y, stereo.x * q1.y + stereo.y * q1.x);

        // Calculate fiber contribution
    float d = length(w - q2);
    fiber += exp(-d * 4.0) *
      (1.0 + 0.5 * sin(d * 12.0 - t));
  }

    // Linking structure
  float link = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create linked fibers
    float theta = float(i) * 1.04719755119;
    vec2 p1 = vec2(cos(t + theta), sin(t + theta)) * 0.7;
    vec2 p2 = vec2(-sin(t + theta), cos(t + theta)) * 0.7;

        // Calculate linking number
    float d1 = length(stereo - p1);
    float d2 = length(stereo - p2);
    link += exp(-(d1 + d2) * 3.0) *
      sin((d1 - d2) * 8.0 - t);
  }

    // Base space mapping
  float base = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create base points
    float phi = float(i) * 1.25663706144;
    vec2 base_point = vec2(cos(t * 0.5 + phi), sin(t * 0.5 + phi)) * 0.8;

        // Calculate base space distance
    float d = length(stereo - base_point);
    base += exp(-d * 5.0) *
      (1.0 + 0.5 * sin(d * 15.0 - t));
  }

    // Total space structure
  float total = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create total space coordinates
    vec2 q = vec2(cos(t * 2.0 + float(i) * 1.57079632679), sin(t * 2.0 + float(i) * 1.57079632679));

        // Calculate structure constants
    float d = length(stereo - q);
    total += exp(-d * 6.0) *
      pow(sin(d * 10.0 - t) * 0.5 + 0.5, 2.0);
  }

    // Combine topological effects with geometric colors
  vec3 fiberColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.1, 0.8), fiber) * fiber;

  vec3 linkColor = mix(vec3(0.2, 0.7, 0.5), vec3(0.8, 0.2, 0.4), link) * link;

  vec3 baseColor = mix(vec3(0.3, 0.6, 1.0), vec3(1.0, 0.3, 0.7), base) * base;

  vec3 totalColor = vec3(0.7, 0.4, 1.0) * total;

    // Final composition with stereographic depth
  float depth = proj_scale *
    (1.0 + 0.2 * sin(angle * 4.0 - t));

  return vec4((fiberColor + linkColor + baseColor + totalColor) * depth, 1.0);
}
