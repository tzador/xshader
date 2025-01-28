float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float neuron(vec2 uv, vec2 pos, float activation) {
  float dist = length(uv - pos);
  float neuron = smoothstep(0.05, 0.04, dist);

  // Add activation glow
  float glow = exp(-dist * 10.0) * activation;

  return neuron + glow;
}

float synapse(vec2 uv, vec2 start, vec2 end, float activation) {
  vec2 dir = normalize(end - start);
  vec2 normal = vec2(-dir.y, dir.x);

  float projection = dot(uv - start, dir);
  float distance = dot(uv - start, normal);

  // Create synapse line
  float line = smoothstep(0.02, 0.0, A(distance)) *
    smoothstep(0.0, 0.02, projection) *
    smoothstep(length(end - start), length(end - start) - 0.02, projection);

  // Add traveling signal
  float signal = S(projection * 10.0 - t * 10.0);
  signal *= smoothstep(0.01, 0.0, A(distance));

  return line * 0.5 + signal * activation;
}

vec2 getLayerPosition(float layer, float neuron, float totalLayers, float neuronsPerLayer) {
  float x = mix(-0.8, 0.8, layer / (totalLayers - 1.0));
  float y = mix(-0.5, 0.5, neuron / (neuronsPerLayer - 1.0));
  return vec2(x, y);
}

float sigmoid(float x) {
  return 1.0 / (1.0 + exp(-x * 2.0));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Network architecture
  float totalLayers = 4.0;
  float neuronsPerLayer = 5.0;

  // Initialize colors
  vec3 color = vec3(0.0);

  // Create neurons and synapses
  for(float layer = 0.0; layer < totalLayers; layer++) {
    for(float n = 0.0; n < neuronsPerLayer; n++) {
      // Calculate neuron position
      vec2 pos = getLayerPosition(layer, n, totalLayers, neuronsPerLayer);

      // Calculate neuron activation based on mouse proximity and time
      float activation = sigmoid(1.0 - length(mousePos - pos) * 2.0);
      activation *= 0.5 + 0.5 * S(t * 2.0 + layer + n);

      // Draw neuron
      float neuronShape = neuron(uv, pos, activation);
      vec3 neuronColor = mix(vec3(0.2, 0.4, 0.8), // Inactive
      vec3(0.8, 0.4, 0.2), // Active
      activation);
      color += neuronColor * neuronShape;

      // Create synapses to next layer
      if(layer < totalLayers - 1.0) {
        for(float next = 0.0; next < neuronsPerLayer; next++) {
          vec2 nextPos = getLayerPosition(layer + 1.0, next, totalLayers, neuronsPerLayer);

          // Calculate synapse weight based on positions
          float weight = sigmoid(hash(vec2(layer * 100.0 + n, next)) * 2.0 - 1.0);

          // Draw synapse
          float synapseShape = synapse(uv, pos, nextPos, activation * weight);
          vec3 synapseColor = mix(vec3(0.2, 0.3, 0.4), // Weak connection
          vec3(0.4, 0.8, 1.0), // Strong connection
          weight * activation);
          color += synapseColor * synapseShape;
        }
      }
    }
  }

  // Add background grid
  vec2 grid = fract(uv * 10.0) - 0.5;
  float gridLines = smoothstep(0.05, 0.0, A(grid.x)) + smoothstep(0.05, 0.0, A(grid.y));
  color += vec3(0.1) * gridLines;

  // Add mouse interaction glow
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += vec3(0.4, 0.6, 0.8) * mouseGlow;

  // Add subtle pulsing
  color *= 0.8 + 0.2 * S(t);

  return vec4(color, 1.0);
}
