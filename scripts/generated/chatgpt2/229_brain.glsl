/*
Neural Network Activity
Creates a visualization of neural network dynamics with
synaptic plasticity and signal propagation patterns.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  vec3 color = vec3(0.0);

    // Network parameters
  const int NEURON_COUNT = 8;
  const float ACTIVATION_SPEED = 2.0;
  const float LEARNING_RATE = 0.5;

    // Neuron positions and states
  vec2 neurons[NEURON_COUNT];
  float activations[NEURON_COUNT];

    // Initialize neurons
  for(int i = 0; i < NEURON_COUNT; i++) {
    float angle = float(i) * 6.28319 / float(NEURON_COUNT);
    neurons[i] = vec2(cos(angle + t * 0.1), sin(angle + t * 0.1));

        // Calculate activation level
    float activation_phase = t * ACTIVATION_SPEED + angle;
    activations[i] = sin(activation_phase) * 0.5 + 0.5;
  }

    // Draw synaptic connections
  for(int i = 0; i < NEURON_COUNT; i++) {
    for(int j = 0; j < NEURON_COUNT; j++) {
      if(i != j) {
                // Calculate synaptic strength
        float strength = sin(length(neurons[i] - neurons[j]) * 4.0 +
          t * LEARNING_RATE) * 0.5 + 0.5;

                // Draw connection
        vec2 synapse_dir = neurons[j] - neurons[i];
        float synapse_len = length(synapse_dir);
        vec2 synapse_norm = synapse_dir / synapse_len;

                // Signal propagation
        float signal_pos = fract((t * ACTIVATION_SPEED + float(i)) / synapse_len);

        vec2 signal_point = neurons[i] +
          synapse_dir * signal_pos;

                // Calculate synapse visibility
        float synapse = exp(-abs(dot(uv - neurons[i], vec2(synapse_norm.y, -synapse_norm.x))) * 8.0);

        synapse *= smoothstep(1.0, 0.0, abs(dot(uv - neurons[i], synapse_norm) / synapse_len - 0.5) * 2.0);

                // Signal pulse
        float pulse = exp(-length(uv - signal_point) * 16.0);
        pulse *= strength * activations[i];

                // Combine with colors
        vec3 synapse_color = mix(vec3(0.1, 0.2, 0.8),  // Weak connection
        vec3(0.2, 0.8, 1.0),  // Strong connection
        strength);

        color += synapse_color * synapse * 0.2;
        color += vec3(1.0, 0.8, 0.4) * pulse;
      }
    }
  }

    // Draw neurons
  for(int i = 0; i < NEURON_COUNT; i++) {
        // Neuron body
    float neuron = exp(-length(uv - neurons[i]) * 8.0);

        // Activation visualization
    float activation_ring = exp(-abs(length(uv - neurons[i]) - 0.2 * activations[i]) * 16.0);

        // Local field potential
    float field = exp(-length(uv - neurons[i]));
    field *= sin(length(uv - neurons[i]) * 8.0 - t * 4.0) * 0.5 + 0.5;

        // Combine with colors
    vec3 neuron_color = mix(vec3(0.2, 0.4, 0.8),  // Inactive
    vec3(0.8, 0.4, 0.2),  // Active
    activations[i]);

    color += neuron_color * neuron;
    color += vec3(0.4, 0.8, 1.0) * activation_ring * 0.3;
    color += vec3(0.2, 0.4, 0.8) * field * 0.1;
  }

    // Add background activity
  vec2 activity_uv = uv * 4.0;
  float activity = sin(activity_uv.x + t) *
    sin(activity_uv.y + t * 1.2);
  activity = activity * 0.5 + 0.5;

  color += vec3(0.1, 0.2, 0.4) * activity * 0.1;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
