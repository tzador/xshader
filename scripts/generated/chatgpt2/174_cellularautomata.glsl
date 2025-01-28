/*
Cellular Automata Evolution
Advanced shader demonstrating:
- Dynamic rule-based pattern generation
- State transition waves and flows
- Emergent behavior visualization
- Multi-state cellular interactions
- Pattern evolution and morphogenesis
Creates a complex cellular automata system with evolutionary behavior
*/

vec4 f() {
    // Initialize cellular grid system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);

    // Cell state parameters
  vec2 cell = uv;
  float state = 0.0;

    // Primary cellular pattern
  float pattern = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create cell grid with time evolution
    float angle = float(i) * 1.04719755119 + t * 0.3;
    vec2 grid = vec2(cell.x * cos(angle) - cell.y * sin(angle), cell.x * sin(angle) + cell.y * cos(angle));

        // Apply cellular rules
    vec2 id = fract(grid * (2.0 + sin(t + float(i)) * 0.5));
    float cell_state = length(id - 0.5);

        // State transition rules
    float transition = exp(-cell_state * 4.0) *
      sin(cell_state * 15.0 - t + float(i));

        // Accumulate pattern
    pattern += transition * (1.0 + 0.5 * sin(cell_state * 8.0 - t));
  }

    // State evolution waves
  float evolution = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create evolution centers
    float phase = float(i) * 1.57079632679;
    vec2 center = vec2(cos(t * 1.5 + phase), sin(t * 1.5 + phase)) * 0.8;

        // Calculate state changes
    float d = length(cell - center);
    evolution += exp(-d * 3.0) *
      (cos(d * 10.0 - t) * 0.5 + 0.5);
  }

    // Interaction field
  float interaction = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create interaction vectors
    float angle = float(i) * 1.25663706144 + t;
    vec2 dir = vec2(cos(angle), sin(angle));

        // Calculate field strength
    float strength = dot(normalize(cell), dir);
    interaction += exp(-abs(strength) * 3.0) *
      sin(strength * 8.0 - t);
  }

    // Combine cellular states with dynamic colors
  vec3 patternColor = mix(vec3(0.1, 0.5, 0.9), vec3(0.9, 0.2, 0.7), pattern) * pattern;

  vec3 evolveColor = mix(vec3(0.2, 0.7, 0.5), vec3(0.8, 0.3, 0.2), evolution) * evolution;

  vec3 interactColor = vec3(0.6, 0.4, 1.0) * interaction;

    // Final composition with cellular depth
  float depth = exp(-dist * 0.4) *
    (1.0 + 0.3 * sin(dist * 4.0 - t));

  return vec4((patternColor + evolveColor + interactColor) * depth, 1.0);
}
