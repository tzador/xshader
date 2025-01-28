/*
Neural Network
Visualizes signal propagation through a neural network
with activation waves and synaptic connections.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  float signal = 0.0;

    // Create neural layers
  for(int i = 0; i < 3; i++) {
    float layer_x = float(i) - 1.0;

        // Neurons in layer
    for(int j = 0; j < 4; j++) {
      float y = (float(j) - 1.5) * 0.5;
      vec2 neuron = vec2(layer_x, y);

            // Activation function
      float activation = sin(t * 2.0 + float(i + j));
      float neuron_signal = exp(-length(uv - neuron) * 4.0) *
        (0.5 + 0.5 * activation);

            // Synaptic connections
      if(i < 2) {
        for(int k = 0; k < 4; k++) {
          float next_y = (float(k) - 1.5) * 0.5;
          vec2 next = vec2(layer_x + 1.0, next_y);

                    // Draw connection
          vec2 dir = next - neuron;
          float synapse = exp(-pow(length(uv - neuron - dir * fract(t + float(j * k) * 0.1)), 2.0) * 40.0);

          signal += synapse * 0.2;
        }
      }

      signal += neuron_signal;
    }
  }

    // Colorize
  vec3 color = mix(vec3(0.1, 0.2, 0.4),  // Dark blue
  vec3(0.2, 0.8, 1.0),  // Bright blue
  signal);

  return vec4(color, 1.0);
}
