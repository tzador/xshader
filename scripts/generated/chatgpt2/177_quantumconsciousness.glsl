/*
Quantum Consciousness Field
Advanced quantum visualization demonstrating:
- Wave function collapse and measurement
- Quantum entanglement networks
- Coherent state superposition
- Neural quantum correlations
- Consciousness field emergence

Physical concepts:
- Wave-particle duality
- Quantum superposition
- Entanglement correlations
- Coherent states
- Quantum measurement theory
*/

vec4 f() {
    // Initialize quantum state space
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  vec2 psi = uv;

    // Quantum phase parameters
  float phase = atan(psi.y, psi.x);
  float amplitude = exp(-dist * 0.5);

    // Wave function superposition
  float wave = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create quantum states
    float energy = float(i) * 1.0471975512;
    vec2 state = vec2(cos(energy + t), sin(energy + t)) * amplitude;

        // Calculate probability amplitude
    float psi_r = length(psi - state);
    float phi = phase + dot(psi, state);

        // Add quantum interference
    wave += exp(-psi_r * 3.0) *
      (cos(phi * 4.0 - t) * 0.5 + 0.5) *
      exp(-length(state) * 2.0);
  }

    // Entanglement network
  float entangle = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create entangled pairs
    float theta = float(i) * 1.25663706144;
    vec2 p1 = vec2(cos(t + theta), sin(t + theta)) * 0.7;
    vec2 p2 = -p1; // Anticorrelated pair

        // Calculate entanglement strength
    float e1 = exp(-length(psi - p1) * 4.0);
    float e2 = exp(-length(psi - p2) * 4.0);

        // Add quantum correlation
    entangle += (e1 * e2) *
      sin(length(p1 - p2) * 6.0 - t);
  }

    // Consciousness field emergence
  float conscious = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create consciousness nodes
    float phi = float(i) * 1.57079632679;
    vec2 node = vec2(cos(t * 1.5 + phi), sin(t * 1.5 + phi)) * 0.8;

        // Calculate field interaction
    float d = length(psi - node);
    conscious += exp(-d * 3.0) *
      (1.0 + 0.5 * sin(d * 10.0 - t));
  }

    // Quantum measurement collapse
  float collapse = 0.0;
  for(int i = 0; i < 3; i++) {
    vec2 measure = vec2(cos(t * 2.0 + float(i) * 2.0944), sin(t * 2.0 + float(i) * 2.0944)) * 0.6;

    float prob = exp(-length(psi - measure) * 5.0);
    collapse += prob * sin(length(psi - measure) * 8.0 - t);
  }

    // Combine quantum effects with spectral colors
  vec3 waveColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.1, 0.8), wave) * wave;

  vec3 entangleColor = mix(vec3(0.2, 0.7, 0.5), vec3(0.8, 0.2, 0.4), entangle) * entangle;

  vec3 consciousColor = mix(vec3(0.3, 0.6, 1.0), vec3(1.0, 0.3, 0.7), conscious) * conscious;

  vec3 collapseColor = vec3(0.7, 0.4, 1.0) * collapse;

    // Final composition with quantum uncertainty
  float uncertainty = exp(-dist * 0.3) *
    (1.0 + 0.3 * sin(dist * 4.0 - t));

  return vec4((waveColor + entangleColor + consciousColor + collapseColor) *
    uncertainty, 1.0);
}
