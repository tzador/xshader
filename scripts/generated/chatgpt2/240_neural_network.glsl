/*
Neural Network Dynamics
Visualizes neural activation patterns, synaptic connections,
and learning processes in a deep neural network.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  vec3 color = vec3(0.0);

    // Network parameters
  float network_time = t * 1.5;
  float learning_rate = 0.8;
  float activation_threshold = 0.6;

    // Layer configuration
  const int LAYERS = 4;
  const int NEURONS_PER_LAYER = 6;

    // Initialize neuron positions
  vec2[LAYERS * NEURONS_PER_LAYER] neurons;
  float[LAYERS * NEURONS_PER_LAYER] activations;

  for(int layer = 0; layer < LAYERS; layer++) {
    float layer_x = mix(-1.5, 1.5, float(layer) / float(LAYERS - 1));

    for(int neuron = 0; neuron < NEURONS_PER_LAYER; neuron++) {
      float neuron_y = mix(-1.0, 1.0, float(neuron) / float(NEURONS_PER_LAYER - 1));
      int idx = layer * NEURONS_PER_LAYER + neuron;

            // Add some dynamic movement to neurons
      neurons[idx] = vec2(layer_x + 0.1 * sin(network_time * 0.5 + float(neuron)), neuron_y + 0.1 * cos(network_time * 0.7 + float(layer)));

            // Calculate neuron activation
      float phase = network_time + float(layer) * 0.5 + float(neuron) * 0.3;
      activations[idx] = sin(phase) * 0.5 + 0.5;
    }
  }

    // Draw synaptic connections
  float connections = 0.0;
  for(int l1 = 0; l1 < LAYERS - 1; l1++) {
    for(int n1 = 0; n1 < NEURONS_PER_LAYER; n1++) {
      int idx1 = l1 * NEURONS_PER_LAYER + n1;
      vec2 pos1 = neurons[idx1];
      float act1 = activations[idx1];

      for(int n2 = 0; n2 < NEURONS_PER_LAYER; n2++) {
        int idx2 = (l1 + 1) * NEURONS_PER_LAYER + n2;
        vec2 pos2 = neurons[idx2];
        float act2 = activations[idx2];

                // Calculate weight based on activations
        float weight = sin(act1 * act2 * 6.28319 + network_time) * 0.5 + 0.5;

                // Draw connection
        vec2 conn_vec = pos2 - pos1;
        float conn_len = length(conn_vec);
        vec2 conn_dir = conn_vec / conn_len;

        float signal = sin(dot(uv - pos1, conn_dir) * 8.0 - network_time * 4.0);
        signal = signal * 0.5 + 0.5;

        float conn = exp(-abs(dot(uv - pos1, vec2(conn_dir.y, -conn_dir.x))) * 8.0);
        conn *= smoothstep(conn_len + 0.1, conn_len - 0.1, length(conn_vec * clamp(dot(uv - pos1, conn_dir) / conn_len, 0.0, 1.0)));

        connections += conn * weight * mix(act1, act2, 0.5);
      }
    }
  }

    // Draw neurons
  float neurons_vis = 0.0;
  for(int i = 0; i < LAYERS * NEURONS_PER_LAYER; i++) {
    vec2 pos = neurons[i];
    float activation = activations[i];

        // Neuron body
    float neuron = exp(-length(uv - pos) * 8.0);

        // Activation potential
    float potential = sin(length(uv - pos) * 16.0 - network_time * 2.0);
    potential = potential * 0.5 + 0.5;

    neurons_vis += neuron * (0.5 + 0.5 * potential) * activation;
  }

    // Add learning effects
  float learning = 0.0;
  for(int i = 0; i < 4; i++) {
    float scale = pow(2.0, float(i));
    vec2 learn_uv = uv * scale + vec2(cos(network_time * 0.3 * scale), sin(network_time * 0.4 * scale));

    float pattern = sin(learn_uv.x + network_time) * sin(learn_uv.y + network_time * 1.2);
    learning += pattern / scale;
  }

    // Create color gradients
  vec3 neuron_color = mix(vec3(0.2, 0.4, 0.8),  // Inactive neurons
  vec3(0.8, 0.4, 0.2),  // Active neurons
  neurons_vis);

  vec3 connection_color = mix(vec3(0.1, 0.3, 0.5),  // Weak connections
  vec3(0.5, 0.8, 1.0),  // Strong connections
  connections);

  vec3 learning_color = mix(vec3(0.2, 0.5, 0.3),  // Low learning activity
  vec3(0.8, 0.7, 0.2),  // High learning activity
  learning * 0.5 + 0.5);

    // Combine visualization components
  color = neuron_color * (1.0 + neurons_vis * 0.5);
  color += connection_color * connections * learning_rate;
  color += learning_color * learning * learning_rate * 0.3;

    // Add activation threshold effects
  float threshold = smoothstep(activation_threshold - 0.1, activation_threshold + 0.1, neurons_vis);
  color += vec3(0.9, 0.8, 0.7) * threshold * 0.2;

    // Add background activity
  vec2 bg_uv = uv * 16.0;
  float bg = sin(bg_uv.x + network_time) * sin(bg_uv.y + network_time * 1.2);
  color += vec3(0.2, 0.3, 0.4) * bg * 0.05;

    // Tone mapping and color adjustment
  color = pow(color, vec3(0.8));
  color = mix(color, vec3(length(color)), 0.1);

  return vec4(color, 1.0);
}
