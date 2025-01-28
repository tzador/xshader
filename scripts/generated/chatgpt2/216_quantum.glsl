/*
Quantum Tunneling
Creates a visualization of quantum tunneling
through a potential barrier.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  float wave = 0.0;

    // Create potential barrier
  float barrier = smoothstep(0.1, -0.1, abs(uv.x) - 0.5);

    // Generate wave packet
  float packet_pos = mod(t, 4.0) - 2.0;
  float packet = exp(-pow(uv.x - packet_pos, 2.0) * 4.0);

    // Wave function phase
  float phase = uv.x * 8.0 - t * 4.0;
  wave = packet * sin(phase);

    // Add tunneling effect
  float tunnel = exp(-pow(abs(uv.x) - 0.5, 2.0) * 4.0);
  wave *= mix(1.0, 0.2, barrier * (1.0 - tunnel));

    // Probability density
  float probability = wave * wave;

    // Create quantum colors
  vec3 color = mix(vec3(0.2, 0.4, 0.8),  // Wave color
  vec3(0.8, 0.2, 0.2),  // Barrier color
  barrier);

    // Add wave function
  color += vec3(probability) * 0.5;

  return vec4(color, 1.0);
}
