/*
Cellular Automata Evolution
Visualizes multiple interacting layers of cellular automata
with emergent patterns and complex state transitions.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Simulation parameters
    float sim_time = t * 2.0;
    float interaction_strength = 0.8;
    float mutation_rate = 0.2;

    // Grid parameters
    const float CELL_SIZE = 0.1;
    const int LAYERS = 3;

    // Cell state function
    float cell_state(vec2 pos, float layer_offset) {
        vec2 grid_pos = floor(pos / CELL_SIZE);
        float random_seed = fract(sin(dot(grid_pos, vec2(127.1, 311.7))) * 43758.5453);

        // Time evolution
        float time_factor = sim_time + layer_offset;
        float state = fract(random_seed + time_factor * 0.1);

        // Add neighborhood influence
        float neighbors = 0.0;
        for(int dx = -1; dx <= 1; dx++) {
            for(int dy = -1; dy <= 1; dy++) {
                if(dx == 0 && dy == 0) continue;

                vec2 neighbor_pos = grid_pos + vec2(dx, dy);
                float neighbor_random = fract(sin(dot(neighbor_pos, vec2(127.1, 311.7))) * 43758.5453);
                float neighbor_state = fract(neighbor_random + time_factor * 0.1);

                neighbors += step(0.5, neighbor_state);
            }
        }

        // Apply Game of Life rules with variations
        float current = step(0.5, state);
        float next_state = current;

        if(current < 0.5) {
            // Birth rule
            next_state = step(2.9, neighbors) * step(neighbors, 3.1);
        } else {
            // Survival rule
            next_state = step(1.9, neighbors) * step(neighbors, 3.1);
        }

        // Add mutation chance
        float mutation = step(1.0 - mutation_rate, fract(random_seed + time_factor * 0.3));
        next_state = mix(next_state, 1.0 - next_state, mutation);

        return next_state;
    }

    // Generate multiple cellular automata layers
    float[LAYERS] layers;
    for(int i = 0; i < LAYERS; i++) {
        float layer_offset = float(i) * 1.0472;
        vec2 offset = vec2(
            cos(sim_time * 0.3 + layer_offset),
            sin(sim_time * 0.4 + layer_offset)
        ) * 0.1;

        layers[i] = cell_state(uv + offset, layer_offset);
    }

    // Calculate layer interactions
    float interaction = 0.0;
    for(int i = 0; i < LAYERS; i++) {
        for(int j = i + 1; j < LAYERS; j++) {
            float phase_diff = abs(layers[i] - layers[j]);
            interaction += phase_diff * (1.0 - phase_diff);
        }
    }

    // Generate emergent patterns
    float patterns = 0.0;
    vec2 pattern_uv = uv * 4.0;
    for(int i = 0; i < LAYERS; i++) {
        float scale = pow(2.0, float(i));
        vec2 pos = pattern_uv * scale + vec2(
            cos(sim_time * 0.2 * scale),
            sin(sim_time * 0.3 * scale)
        );

        float pattern = cell_state(pos, float(i));
        patterns += pattern / scale;
    }

    // Create dynamic boundaries
    float boundaries = 0.0;
    for(int i = 0; i < LAYERS; i++) {
        vec2 boundary_uv = uv * (2.0 + float(i));
        float angle = atan(boundary_uv.y, boundary_uv.x);
        float radius = length(boundary_uv);

        float boundary = sin(angle * 8.0 + radius * 4.0 - sim_time * 2.0);
        boundaries += boundary / float(LAYERS);
    }

    // Combine layer states
    float combined_state = 0.0;
    for(int i = 0; i < LAYERS; i++) {
        combined_state += layers[i] / float(LAYERS);
    }

    // Create color gradients
    vec3 state_color = mix(
        vec3(0.1, 0.2, 0.4),  // Dead cells
        vec3(0.8, 0.7, 0.2),  // Live cells
        combined_state
    );

    vec3 interaction_color = mix(
        vec3(0.2, 0.5, 0.3),  // Low interaction
        vec3(0.7, 0.3, 0.5),  // High interaction
        interaction
    );

    vec3 pattern_color = mix(
        vec3(0.3, 0.4, 0.6),  // Simple patterns
        vec3(0.8, 0.5, 0.3),  // Complex patterns
        patterns
    );

    // Combine visualization components
    color = state_color * (1.0 + combined_state * 0.5);
    color += interaction_color * interaction * interaction_strength;
    color += pattern_color * patterns * 0.3;

    // Add boundary effects
    color += vec3(0.6, 0.7, 0.8) * boundaries * 0.2;

    // Add glowing effects for active regions
    float glow = exp(-length(uv) * 2.0) * combined_state;
    color += vec3(0.8, 0.9, 1.0) * glow * 0.3;

    // Add subtle noise texture
    vec2 noise_uv = uv * 32.0;
    float noise = fract(sin(dot(floor(noise_uv), vec2(127.1, 311.7))) * 43758.5453);
    color += vec3(0.2) * noise * 0.05;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
