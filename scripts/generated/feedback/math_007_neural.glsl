// Cellular Neural Network
// Simulates a grid of neurons with learning

vec4 f() {
    // Network parameters
  float learningRate = 0.1;
  float decayRate = 0.95;
  float threshold = 0.5;
  float connectionStrength = 0.2;

    // Get current state
  vec4 current = texture2D(b, p);

    // Sample neighboring neurons
  float step = 1.0 / 64.0;  // Grid size
  vec2 gridPos = floor(p / step) * step + step / 2.0;

  float activation = 0.0;
  for(int dy = -1; dy <= 1; dy++) {
    for(int dx = -1; dx <= 1; dx++) {
      if(dx == 0 && dy == 0)
        continue;

      vec2 neighbor = gridPos + vec2(dx, dy) * step;
      vec4 neighborState = texture2D(b, neighbor);

            // Weight based on distance and previous state
      float weight = connectionStrength / length(vec2(dx, dy));
      activation += neighborState.r * weight;
    }
  }

    // Apply activation function (sigmoid-like)
  activation = 1.0 / (1.0 + exp(-activation * 4.0));

    // Create learning pattern (rotating wave)
  vec2 center = vec2(0.5);
  float dist = length(p - center);
  float angle = atan(p.y - center.y, p.x - center.x);
  float pattern = sin(dist * 20.0 + angle * 3.0 + t) * 0.5 + 0.5;

    // Update weights through learning
  float error = pattern - current.r;
  float deltaWeight = error * learningRate;

    // New neuron state
  float newState = clamp(activation + deltaWeight, 0.0, 1.0);

    // Visualization colors
  vec4 neuronColor = vec4(newState, activation * 0.8, pattern * 0.6, 1.0);

    // Add synaptic connections visualization
  float synapses = sin(p.x * 50.0 + t) * sin(p.y * 50.0 + t * 0.7) * 0.1;

    // Sample previous frame with slight diffusion
  vec2 diffuseOffset = vec2(sin(activation * 6.28318) * 0.001, cos(activation * 6.28318) * 0.001);
  vec4 previous = texture2D(b, p + diffuseOffset) * decayRate;

    // Combine everything
  return max(neuronColor + synapses, previous);
}
