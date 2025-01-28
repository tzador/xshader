/*
Hyperbolic Neural Network
Advanced visualization demonstrating:
- Neural network in hyperbolic space
- Non-euclidean geometry patterns
- Hierarchical network structure
- Learning trajectory visualization
- Information flow in curved space

Mathematical concepts:
- Hyperbolic geometry
- Poincaré disk model
- Möbius transformations
- Gradient flows
- Neural activation
*/

vec4 f() {
    // Initialize hyperbolic coordinates
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Poincaré disk mapping
  vec2 z = uv * 0.5;
  float hyp_dist = 2.0 * atanh(min(dist, 0.99));

    // Neural activation pattern
  float activation = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create neural nodes
    float theta = float(i) * 1.0471975512;
    vec2 node = vec2(cos(theta + t), sin(theta + t)) * 0.7;

        // Apply hyperbolic transformation
    float denom = 1.0 + 2.0 * dot(z, node) + dot(node, node);
    vec2 w = (z + node) / denom;

        // Calculate activation strength
    float d = length(w);
    activation += exp(-d * 4.0) *
      (1.0 + 0.5 * sin(d * 12.0 - t));
  }

    // Information flow in hyperbolic space
  float flow = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create flow vectors
    float phase = float(i) * 1.25663706144;
    vec2 dir = vec2(cos(phase), sin(phase));

        // Calculate hyperbolic flow
    float stream = dot(normalize(z), dir);
    flow += exp(-abs(stream) * 3.0) *
      sin(hyp_dist * 4.0 - t);
  }

    // Learning trajectory
  float learn = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create learning paths
    float time = t * (1.0 + float(i) * 0.2);
    vec2 path = vec2(cos(time), sin(time)) * (0.5 + float(i) * 0.1);

        // Calculate learning progress
    float d = length(z - path);
    learn += exp(-d * 5.0) *
      pow(sin(d * 8.0 - t) * 0.5 + 0.5, 2.0);
  }

    // Network hierarchy
  float hierarchy = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create hierarchical levels
    float level = float(i) * 0.2;
    float r = abs(hyp_dist - level);

        // Add level contribution
    hierarchy += exp(-r * 6.0) *
      sin(r * 15.0 - t + float(i));
  }

    // Combine network effects with hyperbolic colors
  vec3 activateColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.1, 0.8), activation) * activation;

  vec3 flowColor = mix(vec3(0.2, 0.7, 0.5), vec3(0.8, 0.2, 0.4), flow) * flow;

  vec3 learnColor = mix(vec3(0.3, 0.6, 1.0), vec3(1.0, 0.3, 0.7), learn) * learn;

  vec3 hierColor = vec3(0.7, 0.4, 1.0) * hierarchy;

    // Final composition with hyperbolic depth
  float depth = 1.0 / (1.0 + hyp_dist * 0.3);

  return vec4((activateColor + flowColor + learnColor + hierColor) * depth, 1.0);
}
