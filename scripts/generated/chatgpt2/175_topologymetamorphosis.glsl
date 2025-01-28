/*
Topology Metamorphosis
Advanced shader demonstrating:
- Continuous deformation of geometric surfaces
- Differential geometry visualization
- Genus-changing topological transitions
- Curvature flow patterns
- Complex manifold transformations
Creates a visualization of dynamic topological changes
*/

vec4 f() {
    // Initialize manifold coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Topological parameters
  vec2 z = uv;
  float genus = 0.0;

    // Primary surface deformation
  float surface = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create deformation field
    float phase = float(i) * 1.04719755119;
    vec2 w = vec2(z.x * cos(t + phase) - z.y * sin(t + phase), z.x * sin(t + phase) + z.y * cos(t + phase));

        // Calculate surface curvature
    float k = length(fract(w * (1.5 + sin(t) * 0.5)) - 0.5);
    float curve = exp(-k * 5.0) *
      (1.0 + 0.5 * sin(k * 12.0 - t));

        // Accumulate deformation
    surface += curve * (1.0 + 0.3 * sin(length(w) * 6.0 - t));
  }

    // Genus-changing transitions
  float topology = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create topological singularities
    float r = 0.6 + float(i) * 0.2;
    float theta = t * (1.0 + float(i) * 0.2);
    vec2 singular = vec2(r * cos(theta), r * sin(theta));

        // Calculate topological transition
    float d = length(z - singular);
    topology += exp(-d * 4.0) *
      pow(sin(d * 8.0 - t) * 0.5 + 0.5, 2.0);
  }

    // Curvature flow patterns
  float flow = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create flow vectors
    float angle = float(i) * 1.25663706144 + t;
    vec2 dir = vec2(cos(angle), sin(angle));

        // Calculate flow intensity
    float stream = dot(normalize(z), dir);
    flow += exp(-abs(stream) * 3.0) *
      sin(stream * 10.0 - t + angle);
  }

    // Combine topological effects with dynamic colors
  vec3 surfaceColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.2, 0.8), surface) * surface;

  vec3 topoColor = mix(vec3(0.2, 0.8, 0.5), vec3(0.8, 0.3, 0.2), topology) * topology;

  vec3 flowColor = vec3(0.6, 0.3, 1.0) * flow;

    // Final composition with manifold depth
  float depth = exp(-dist * 0.5) *
    (1.0 + 0.2 * sin(angle * 3.0 - t));

  return vec4((surfaceColor + topoColor + flowColor) * depth, 1.0);
}
