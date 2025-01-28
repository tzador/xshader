/*
Quantum Chaos
Visualizes chaotic quantum systems, level statistics,
quantum scarring, and ergodic dynamics.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Chaos parameters
    float chaos_time = t * 2.0;
    float nonlinearity = 0.9;
    float coupling = 0.8;

    // System parameters
    const int ENERGY_LEVELS = 8;
    const float PLANCK_SCALE = 0.1;

    // Chaos noise function
    float chaos_noise(vec2 p, float freq) {
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

    // Generate energy levels
    float total_energy = 0.0;
    vec2 phase_flow = vec2(0.0);

    for(int i = 0; i < ENERGY_LEVELS; i++) {
        float phase = float(i) * 6.28319 / float(ENERGY_LEVELS);
        vec2 level_pos = vec2(
            cos(phase + chaos_time * 0.3),
            sin(phase + chaos_time * 0.4)
        ) * 1.5;

        // Calculate energy and phase space
        vec2 rel_pos = uv - level_pos;
        float dist = length(rel_pos);

        // Energy with chaotic modulation
        float energy = exp(-dist * 2.0) * sin(dist * 8.0 + chaos_time * (1.0 + float(i) * 0.1));
        energy *= 1.0 + nonlinearity * sin(chaos_time * sqrt(float(i + 1)));

        total_energy += energy;
        phase_flow += normalize(rel_pos) * energy;
    }

    // Calculate level statistics
    float level_spacing = 0.0;
    for(int i = 0; i < ENERGY_LEVELS - 1; i++) {
        float e1 = float(i) * 6.28319 / float(ENERGY_LEVELS);
        float e2 = float(i + 1) * 6.28319 / float(ENERGY_LEVELS);

        float spacing = abs(sin(e2 + chaos_time) - sin(e1 + chaos_time));
        level_spacing += spacing * exp(-float(i));
    }

    // Generate quantum scars
    float scarring = 0.0;
    vec2 scar_center = vec2(
        cos(chaos_time * 0.5),
        sin(chaos_time * 0.7)
    );

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 scar_dir = vec2(cos(angle), sin(angle));

        // Unstable periodic orbits
        float orbit = exp(-abs(dot(uv - scar_center, scar_dir)) * 4.0);
        orbit *= sin(dot(uv - scar_center, scar_dir) * 16.0 - chaos_time * 4.0);

        scarring += orbit;
    }

    // Calculate ergodic dynamics
    float ergodicity = 0.0;
    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        vec2 ergodic_pos = uv * scale + phase_flow * chaos_time;

        float chaos = chaos_noise(ergodic_pos, 2.0);
        chaos = pow(chaos, 1.5); // Non-linear chaos amplification

        ergodicity += chaos / scale;
    }

    // Generate quantum interference
    float interference = 0.0;
    for(int i = 0; i < ENERGY_LEVELS; i++) {
        for(int j = i + 1; j < ENERGY_LEVELS; j++) {
            float phase_i = float(i) * 6.28319 / float(ENERGY_LEVELS);
            float phase_j = float(j) * 6.28319 / float(ENERGY_LEVELS);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            float pattern = sin(length(uv - pos_i) * 8.0 - chaos_time) *
                           sin(length(uv - pos_j) * 8.0 - chaos_time);
            interference += pattern * coupling;
        }
    }

    // Calculate quantum entanglement
    float entanglement = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 ent_pos = uv * scale + vec2(
            cos(chaos_time * 0.2 * scale),
            sin(chaos_time * 0.3 * scale)
        );

        float ent = chaos_noise(ent_pos, 4.0);
        entanglement += ent / scale;
    }

    // Create color gradients
    vec3 energy_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low energy
        vec3(0.8, 0.3, 0.2),  // High energy
        total_energy * 0.5 + 0.5
    );

    vec3 spacing_color = mix(
        vec3(0.3, 0.7, 0.2),  // Regular spacing
        vec3(0.9, 0.8, 0.3),  // Chaotic spacing
        level_spacing
    );

    vec3 scar_color = mix(
        vec3(0.2, 0.3, 0.5),  // Background
        vec3(0.7, 0.5, 0.8),  // Quantum scars
        scarring
    );

    // Combine visualization components
    color = energy_color * (1.0 + total_energy * 0.5);
    color += spacing_color * level_spacing * nonlinearity;
    color += scar_color * scarring * 0.3;

    // Add ergodic effects
    vec3 ergodic_color = mix(
        vec3(0.4, 0.6, 0.8),  // Regular dynamics
        vec3(0.8, 0.7, 0.3),  // Ergodic dynamics
        ergodicity
    );
    color += ergodic_color * ergodicity * 0.3;

    // Add interference patterns
    color += vec3(0.6, 0.7, 0.8) * interference * 0.2;

    // Add entanglement visualization
    color = mix(
        color,
        vec3(0.8, 0.6, 0.9),
        entanglement * 0.2
    );

    // Add phase space flow
    float flow = sin(dot(normalize(phase_flow), uv) * 8.0 - chaos_time * 2.0);
    flow = flow * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow * 0.1;

    // Add quantum fluctuations
    vec2 quantum_uv = uv * 16.0;
    float quantum = chaos_noise(quantum_uv + chaos_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * quantum * PLANCK_SCALE;

    // Add Berry phase effects
    float berry_phase = atan(uv.y, uv.x) + chaos_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(berry_phase * 4.0) * 0.5 + 0.5) * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
