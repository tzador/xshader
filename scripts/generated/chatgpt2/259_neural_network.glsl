/*
Neural Network Dynamics
Visualizes neural network activation patterns,
weight updates, and learning processes.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Network parameters
    float net_time = t * 1.5;
    float learning_rate = 0.8;
    float activation_threshold = 0.6;

    // Layer configuration
    const int LAYERS = 4;
    const int NEURONS_PER_LAYER = 6;
    const float LAYER_SPACING = 2.0;

    // Neural noise function
    float neural_noise(vec2 p, float freq) {
        vec2 i = floor(p * freq);
        vec2 f = fract(p * freq);

        float a = fract(sin(dot(i, vec2(127.1, 311.7))) * 43758.5453);
        float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
        float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
        float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        f = f * f * (3.0 - 2.0 * f);

        return mix(
            mix(a, b, f.x),
            mix(c, d, f.x),
            f.y
        );
    }

    // Activation function (sigmoid)
    float sigmoid(float x) {
        return 1.0 / (1.0 + exp(-x * 2.0));
    }

    // Calculate neuron positions and activations
    float total_activation = 0.0;
    vec2 network_flow = vec2(0.0);

    for(int layer = 0; layer < LAYERS; layer++) {
        float layer_x = (float(layer) / float(LAYERS - 1) - 0.5) * LAYER_SPACING;

        for(int neuron = 0; neuron < NEURONS_PER_LAYER; neuron++) {
            float neuron_y = (float(neuron) / float(NEURONS_PER_LAYER - 1) - 0.5) * 2.0;
            vec2 neuron_pos = vec2(layer_x, neuron_y);

            // Calculate neuron activation
            vec2 rel_pos = uv - neuron_pos;
            float dist = length(rel_pos);

            float activation = sigmoid(1.0 - dist * 2.0);
            activation *= sin(net_time * (1.0 + float(layer) * 0.2 + float(neuron) * 0.1));

            if(activation > activation_threshold) {
                total_activation += activation;
                network_flow += normalize(rel_pos) * activation;
            }
        }
    }

    // Generate weight connections
    float weight_strength = 0.0;
    for(int l1 = 0; l1 < LAYERS - 1; l1++) {
        float x1 = (float(l1) / float(LAYERS - 1) - 0.5) * LAYER_SPACING;
        float x2 = (float(l1 + 1) / float(LAYERS - 1) - 0.5) * LAYER_SPACING;

        for(int n1 = 0; n1 < NEURONS_PER_LAYER; n1++) {
            for(int n2 = 0; n2 < NEURONS_PER_LAYER; n2++) {
                float y1 = (float(n1) / float(NEURONS_PER_LAYER - 1) - 0.5) * 2.0;
                float y2 = (float(n2) / float(NEURONS_PER_LAYER - 1) - 0.5) * 2.0;

                vec2 pos1 = vec2(x1, y1);
                vec2 pos2 = vec2(x2, y2);

                // Calculate weight visualization
                vec2 weight_dir = pos2 - pos1;
                float weight = exp(-length(cross(vec3(uv - pos1, 0.0), vec3(weight_dir, 0.0))).z * 8.0);
                weight *= sin(net_time * (1.0 + float(l1) * 0.3 + float(n1 + n2) * 0.1));

                weight_strength += weight * learning_rate;
            }
        }
    }

    // Calculate backpropagation effects
    float backprop = 0.0;
    for(int layer = LAYERS - 1; layer >= 0; layer--) {
        float layer_x = (float(layer) / float(LAYERS - 1) - 0.5) * LAYER_SPACING;
        vec2 backprop_pos = uv - vec2(layer_x, 0.0);

        float error = neural_noise(backprop_pos + net_time * 0.2, 2.0);
        error = pow(error, 1.5);

        backprop += error * exp(-float(LAYERS - 1 - layer));
    }

    // Generate learning patterns
    float learning = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 learn_pos = uv * scale + network_flow * net_time;

        float pattern = neural_noise(learn_pos, 2.0);
        learning += pattern / scale;
    }

    // Create gradient descent visualization
    float gradient = 0.0;
    vec2 grad_center = vec2(
        cos(net_time * 0.3),
        sin(net_time * 0.4)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 grad_dir = vec2(cos(angle), sin(angle));

        float grad_val = exp(-abs(dot(uv - grad_center, grad_dir)) * 3.0);
        grad_val *= sin(dot(uv - grad_center, grad_dir) * 12.0 - net_time * 3.0);

        gradient += grad_val;
    }

    // Create color gradients
    vec3 activation_color = mix(
        vec3(0.2, 0.3, 0.7),  // Low activation
        vec3(0.8, 0.4, 0.2),  // High activation
        total_activation * 0.5
    );

    vec3 weight_color = mix(
        vec3(0.3, 0.6, 0.2),  // Weak connections
        vec3(0.7, 0.8, 0.3),  // Strong connections
        weight_strength
    );

    vec3 backprop_color = mix(
        vec3(0.2, 0.4, 0.6),  // Low error
        vec3(0.8, 0.3, 0.4),  // High error
        backprop
    );

    // Combine visualization components
    color = activation_color * (1.0 + total_activation * 0.3);
    color += weight_color * weight_strength * 0.4;
    color += backprop_color * backprop * 0.3;

    // Add learning effects
    vec3 learning_color = mix(
        vec3(0.4, 0.5, 0.7),  // Stable state
        vec3(0.7, 0.6, 0.3),  // Learning state
        learning
    );
    color += learning_color * learning * 0.2;

    // Add gradient descent visualization
    color += vec3(0.6, 0.7, 0.8) * gradient * 0.15;

    // Add network flow
    float flow = sin(dot(normalize(network_flow), uv) * 6.0 - net_time * 2.0);
    flow = flow * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow * 0.1;

    // Add activation thresholds
    vec2 threshold_uv = uv * 12.0;
    float threshold = neural_noise(threshold_uv + net_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * threshold * 0.1;

    // Add optimization landscape
    float landscape = atan(uv.y, uv.x) + net_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(landscape * 3.0) * 0.5 + 0.5) * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
