/*
Morphogenetic Field Evolution
Advanced visualization demonstrating:
- Biological pattern formation
- Reaction-diffusion systems
- Chemical gradient flows
- Cellular differentiation
- Tissue layer organization

Biological concepts:
- Morphogen gradients
- Turing patterns
- Cell signaling
- Pattern formation
- Developmental biology
*/

vec4 f() {
    // Initialize tissue coordinates
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Morphogen parameters
  float time_scale = t * 0.3;
  vec2 morph_dir = vec2(cos(time_scale), sin(time_scale));

    // Primary morphogen gradient
  float morphogen = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create morphogen sources
    float phase = float(i) * 1.0471975512;
    vec2 source = vec2(cos(phase + t), sin(phase + t)) * 0.7;

        // Calculate concentration gradient
    float d = length(uv - source);
    float diff = exp(-d * 3.0);

        // Add reaction-diffusion term
    morphogen += diff *
      (1.0 + 0.5 * sin(d * 8.0 - time_scale));
  }

    // Cell signaling network
  float signal = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create signaling centers
    float theta = float(i) * 1.25663706144;
    vec2 center = vec2(cos(t * 1.2 + theta), sin(t * 1.2 + theta)) * 0.8;

        // Calculate signal strength
    float r = length(uv - center);
    signal += exp(-r * 4.0) *
      sin(r * 12.0 - time_scale + theta);
  }

    // Tissue differentiation
  float tissue = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create tissue layers
    float radius = 0.4 + float(i) * 0.2;
    float layer = abs(dist - radius);

        // Add differentiation pattern
    tissue += exp(-layer * 5.0) *
      (1.0 + 0.5 * sin(layer * 15.0 - t));
  }

    // Pattern formation dynamics
  float pattern = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create pattern vectors
    vec2 dir = vec2(cos(t + float(i) * 2.0944), sin(t + float(i) * 2.0944));

        // Calculate pattern strength
    float field = dot(normalize(uv), dir);
    pattern += exp(-abs(field) * 3.0) *
      sin(field * 10.0 - time_scale);
  }

    // Combine biological effects with tissue colors
  vec3 morphColor = mix(vec3(0.1, 0.5, 0.9), vec3(0.9, 0.2, 0.7), morphogen) * morphogen;

  vec3 signalColor = mix(vec3(0.2, 0.7, 0.4), vec3(0.8, 0.3, 0.2), signal) * signal;

  vec3 tissueColor = mix(vec3(0.3, 0.6, 1.0), vec3(1.0, 0.4, 0.6), tissue) * tissue;

  vec3 patternColor = vec3(0.7, 0.5, 1.0) * pattern;

    // Final composition with tissue depth
  float depth = exp(-dist * 0.5) *
    (1.0 + 0.2 * sin(angle * 4.0 - time_scale));

  return vec4((morphColor + signalColor + tissueColor + patternColor) * depth, 1.0);
}
