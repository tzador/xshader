/*
Quantum Field
Visualizes quantum field fluctuations with interference
patterns and particle-like behavior.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  float field = 0.0;

    // Create quantum particles
  for(int i = 0; i < 6; i++) {
        // Particle position
    float phase = float(i) * 1.0472;
    vec2 pos = vec2(cos(t + phase), sin(t * 1.5 + phase));

        // Wave function
    float psi = exp(-length(uv - pos));
    float probability = psi * psi;

        // Add interference
    field += probability * sin(length(uv - pos) * 8.0 - t * 3.0);
  }

    // Normalize and colorize
  field = 0.5 + 0.5 * field;
  vec3 color = vec3(field * 0.7, field * field, 1.0 - field * 0.5);

  return vec4(color, 1.0);
}
