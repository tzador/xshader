/*
Quantum Field Theory
Visualizes quantum field fluctuations, particle creation/annihilation,
and vacuum energy effects in quantum fields.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Quantum parameters
    float qft_time = t * 2.0;
    float field_strength = 0.9;
    float vacuum_energy = 0.8;

    // System parameters
    const int FIELD_MODES = 8;
    const float PLANCK_SCALE = 0.1;

    // Quantum noise function
    float quantum_noise(vec2 p, float freq) {
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

    // Generate quantum field modes
    float field_value = 0.0;
    vec2 field_gradient = vec2(0.0);

    for(int i = 0; i < FIELD_MODES; i++) {
        float phase = float(i) * 6.28319 / float(FIELD_MODES);
        vec2 mode_vector = vec2(
            cos(phase + qft_time * 0.3),
            sin(phase + qft_time * 0.4)
        );

        // Field oscillations
        float amplitude = 1.0 / sqrt(float(i + 1));
        float frequency = float(i + 1) * 3.14159;

        float mode = amplitude * sin(dot(uv, mode_vector) * frequency + qft_time);
        field_value += mode;
        field_gradient += mode_vector * mode;
    }

    // Calculate vacuum fluctuations
    float vacuum = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 vacuum_pos = uv * scale + field_gradient * qft_time;

        vacuum += quantum_noise(vacuum_pos, 1.0) / scale;
    }

    // Generate particle creation/annihilation events
    float particles = 0.0;
    vec2 particle_center = vec2(
        cos(qft_time * 0.5),
        sin(qft_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        // Particle pair creation
        float creation = exp(-length(uv - particle_center - offset) * 4.0);
        creation *= sin(length(uv - particle_center) * 8.0 - qft_time * 4.0);

        // Virtual particle effects
        float virtual_particle = sin(dot(uv - particle_center - offset, vec2(cos(qft_time), sin(qft_time))) * 8.0);

        particles += creation * (1.0 + 0.5 * virtual_particle);
    }

    // Calculate quantum interactions
    float interactions = 0.0;
    for(int i = 0; i < FIELD_MODES; i++) {
        for(int j = i + 1; j < FIELD_MODES; j++) {
            float phase_i = float(i) * 6.28319 / float(FIELD_MODES);
            float phase_j = float(j) * 6.28319 / float(FIELD_MODES);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            // Feynman diagram-like interaction
            float interaction = exp(-length(uv - pos_i) * 2.0) * exp(-length(uv - pos_j) * 2.0);
            interaction *= sin(qft_time * (float(i + j) * 0.1));

            interactions += interaction;
        }
    }

    // Generate quantum entanglement patterns
    float entanglement = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 ent_pos = uv * scale + vec2(
            cos(qft_time * 0.3 * scale),
            sin(qft_time * 0.4 * scale)
        );

        float pattern = quantum_noise(ent_pos, 2.0);
        pattern = pow(pattern, 2.0); // Non-linear quantum correlation

        entanglement += pattern / scale;
    }

    // Calculate Planck scale effects
    float planck_effects = 0.0;
    vec2 planck_uv = uv / PLANCK_SCALE;

    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 planck_pos = planck_uv * scale;

        float effect = quantum_noise(planck_pos + qft_time, 4.0);
        planck_effects += effect / scale;
    }

    // Create color gradients
    vec3 field_color = mix(
        vec3(0.2, 0.4, 0.8),  // Ground state
        vec3(0.8, 0.3, 0.2),  // Excited state
        field_value * 0.5 + 0.5
    );

    vec3 vacuum_color = mix(
        vec3(0.3, 0.7, 0.2),  // Low energy vacuum
        vec3(0.9, 0.8, 0.3),  // High energy vacuum
        vacuum
    );

    vec3 particle_color = mix(
        vec3(0.2, 0.3, 0.5),  // Virtual particles
        vec3(0.7, 0.5, 0.8),  // Real particles
        particles
    );

    // Combine visualization components
    color = field_color * (1.0 + field_value * 0.5);
    color += vacuum_color * vacuum * vacuum_energy;
    color += particle_color * particles * field_strength;

    // Add interaction effects
    vec3 interaction_color = mix(
        vec3(0.4, 0.6, 0.8),  // Weak interaction
        vec3(0.8, 0.7, 0.3),  // Strong interaction
        interactions
    );
    color += interaction_color * interactions * 0.3;

    // Add entanglement visualization
    color = mix(
        color,
        vec3(0.6, 0.8, 0.9),
        entanglement * 0.2
    );

    // Add Planck scale effects
    color *= 1.0 + planck_effects * PLANCK_SCALE;

    // Add quantum interference patterns
    vec2 interference_uv = uv * 8.0;
    float interference = sin(interference_uv.x + qft_time) * sin(interference_uv.y + qft_time * 1.2);
    color += vec3(0.5, 0.6, 0.7) * interference * 0.1;

    // Add vacuum polarization
    float polarization = length(field_gradient);
    color = mix(
        color,
        vec3(0.9, 0.8, 0.7),
        polarization * 0.2
    );

    // Add quantum foam
    vec2 foam_uv = uv * 32.0;
    float foam = quantum_noise(foam_uv + qft_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * foam * PLANCK_SCALE;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
