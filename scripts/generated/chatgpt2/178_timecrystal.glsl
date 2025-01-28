/*
Time Crystal Computer
Advanced visualization demonstrating:
- Periodic temporal structures
- Quantum state processing
- Information flow through time
- Discrete time symmetry breaking
- Computational state evolution

Physical concepts:
- Time translation symmetry
- Quantum state manipulation
- Phase space dynamics
- Information entropy
- Quantum computation
*/

vec4 f() {
    // Initialize spacetime coordinates
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time crystal parameters
  float temporal_phase = t * 0.5;
  vec2 crystal_basis = vec2(cos(temporal_phase), sin(temporal_phase));

    // Quantum state evolution
  float state = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create temporal lattice points
    float time_slice = float(i) * 1.0471975512;
    vec2 lattice = vec2(cos(time_slice + t * 2.0), sin(time_slice + t * 2.0)) * crystal_basis;

        // Calculate quantum state
    float r = length(uv - lattice);
    float phase = angle + dot(uv, lattice);

        // Add temporal evolution
    state += exp(-r * 3.0) *
      (cos(phase * 4.0 - t) * 0.5 + 0.5) *
      exp(-length(lattice) * 2.0);
  }

    // Information processing flow
  float info = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create processing nodes
    float theta = float(i) * 1.25663706144;
    vec2 node = vec2(cos(t + theta) * crystal_basis.x, sin(t + theta) * crystal_basis.y) * 0.8;

        // Calculate information flow
    float d = length(uv - node);
    info += exp(-d * 4.0) *
      sin(d * 8.0 - temporal_phase);
  }

    // Time symmetry breaking
  float symmetry = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create symmetry points
    vec2 point = vec2(cos(t * (1.0 + float(i) * 0.2)), sin(t * (1.0 + float(i) * 0.2))) * 0.7;

        // Calculate symmetry breaking
    float r = length(uv - point);
    symmetry += exp(-r * 3.0) *
      pow(sin(r * 6.0 - t) * 0.5 + 0.5, 2.0);
  }

    // Computational state transitions
  float compute = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create computation vectors
    float phase = float(i) * 1.57079632679 + temporal_phase;
    vec2 dir = vec2(cos(phase), sin(phase));

        // Calculate state transition
    float process = dot(normalize(uv), dir);
    compute += exp(-abs(process) * 3.0) *
      sin(process * 10.0 - t);
  }

    // Combine effects with temporal colors
  vec3 stateColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.1, 0.8), state) * state;

  vec3 infoColor = mix(vec3(0.2, 0.8, 0.5), vec3(0.8, 0.2, 0.4), info) * info;

  vec3 symColor = mix(vec3(0.3, 0.6, 1.0), vec3(1.0, 0.3, 0.7), symmetry) * symmetry;

  vec3 compColor = vec3(0.7, 0.4, 1.0) * compute;

    // Final composition with temporal phase
  float temporal_factor = exp(-dist * 0.4) *
    (1.0 + 0.2 * sin(temporal_phase * 3.0));

  return vec4((stateColor + infoColor + symColor + compColor) *
    temporal_factor, 1.0);
}
