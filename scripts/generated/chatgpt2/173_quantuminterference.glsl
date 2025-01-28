/*
Quantum Interference Manifold
Advanced shader demonstrating:
- Wave function collapse visualization
- Quantum probability density flows
- Entanglement and superposition effects
- Complex phase space mapping
- Quantum interference patterns
Creates a visualization of quantum mechanical phenomena
*/

vec4 f() {
    // Initialize quantum coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);

    // Wave function parameters
  vec2 psi = uv;
  float phase = atan(psi.y, psi.x);

    // Primary wave function
  float wave = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create quantum states
    float energy = float(i) * 1.0471975512;
    vec2 state = vec2(cos(energy + t), sin(energy + t));

        // Calculate probability amplitude
    float amp = exp(-length(psi - state) * 3.0);
    float phi = phase + dot(psi, state);

        // Add quantum interference
    wave += amp * (cos(phi * 5.0 - t) * 0.5 + 0.5) *
      exp(-length(psi - state) * 2.0);
  }

    // Entanglement patterns
  float entangle = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create entangled pairs
    float angle = float(i) * 1.57079632679;
    vec2 p1 = vec2(cos(angle + t), sin(angle + t)) * 0.7;
    vec2 p2 = -p1;

        // Calculate entanglement strength
    float e1 = exp(-length(psi - p1) * 4.0);
    float e2 = exp(-length(psi - p2) * 4.0);

        // Add quantum correlation
    entangle += (e1 * e2) * sin(length(p1 - p2) * 8.0 - t);
  }

    // Probability density flow
  float density = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create probability currents
    float phase = float(i) * 1.25663706144;
    vec2 flow = vec2(cos(t * 1.5 + phase), sin(t * 1.5 + phase));

        // Add density contribution
    density += exp(-length(psi - flow) * 3.0) *
      sin(dot(psi, flow) * 4.0 - t);
  }

    // Combine quantum effects with spectral colors
  vec3 waveColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.2, 0.8), wave) * wave;

  vec3 entangleColor = mix(vec3(0.2, 0.8, 0.5), vec3(0.8, 0.3, 0.2), entangle) * entangle;

  vec3 densityColor = vec3(0.6, 0.3, 1.0) * density;

    // Final composition with quantum uncertainty
  float uncertainty = exp(-dist * 0.5) *
    (1.0 + 0.2 * sin(dist * 6.0 - t));

  return vec4((waveColor + entangleColor + densityColor) * uncertainty, 1.0);
}
