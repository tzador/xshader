/*
Quantum Entanglement Network
Visualizes entangled particle systems,
quantum teleportation, and Bell states.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Quantum parameters
    float quantum_time = t * 1.0;
    float entanglement_strength = 0.8;
    float decoherence_rate = 0.3;

    // System constants
    const int PARTICLE_PAIRS = 6;
    const float PLANCK_CONSTANT = 0.1;
    const float SPIN_COUPLING = 0.9;

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

    // Generate entangled particle pairs
    float total_entanglement = 0.0;
    vec2 quantum_flow = vec2(0.0);

    for(int i = 0; i < PARTICLE_PAIRS; i++) {
        float phase = float(i) * 6.28319 / float(PARTICLE_PAIRS);

        // Particle A position
        vec2 particleA_pos = vec2(
            cos(phase + quantum_time * 0.3),
            sin(phase + quantum_time * 0.4)
        ) * 1.5;

        // Particle B position (entangled partner)
        vec2 particleB_pos = vec2(
            cos(phase + quantum_time * 0.3 + 3.14159),
            sin(phase + quantum_time * 0.4 + 3.14159)
        ) * 1.5;

        // Calculate entanglement effects
        vec2 rel_posA = uv - particleA_pos;
        vec2 rel_posB = uv - particleB_pos;
        float distA = length(rel_posA);
        float distB = length(rel_posB);

        // Quantum state superposition
        float state = sin(distA * 8.0 - quantum_time) * sin(distB * 8.0 - quantum_time);
        state *= exp(-(distA + distB) * 0.5);

        total_entanglement += state * entanglement_strength;
        quantum_flow += (normalize(rel_posA) + normalize(rel_posB)) * state;
    }

    // Calculate Bell states
    float bell_state = 0.0;
    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 bell_dir = vec2(cos(angle), sin(angle));

        float state = exp(-abs(dot(uv, bell_dir)) * 3.0);
        state *= sin(dot(uv, bell_dir) * 8.0 - quantum_time * 2.0);

        bell_state += state;
    }

    // Generate quantum teleportation
    float teleportation = 0.0;
    vec2 teleport_center = vec2(
        cos(quantum_time * 0.5),
        sin(quantum_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 teleport_pos = uv * scale + quantum_flow * quantum_time;

        float port = quantum_noise(teleport_pos, 4.0);
        teleportation += port / scale;
    }

    // Calculate quantum interference
    float interference = 0.0;
    for(int i = 0; i < PARTICLE_PAIRS; i++) {
        for(int j = i + 1; j < PARTICLE_PAIRS; j++) {
            float phase_i = float(i) * 6.28319 / float(PARTICLE_PAIRS);
            float phase_j = float(j) * 6.28319 / float(PARTICLE_PAIRS);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            float pattern = sin(length(uv - pos_i) * 8.0 - quantum_time) *
                           sin(length(uv - pos_j) * 8.0 - quantum_time);
            interference += pattern * SPIN_COUPLING;
        }
    }

    // Generate decoherence effects
    float decoherence = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 decoh_pos = uv * scale + vec2(quantum_time * 0.2);

        float decoh = quantum_noise(decoh_pos, 2.0);
        decoherence += decoh / scale;
    }
    decoherence *= decoherence_rate;

    // Create color gradients
    vec3 entanglement_color = mix(
        vec3(0.2, 0.4, 0.8),  // Unentangled state
        vec3(0.8, 0.3, 0.2),  // Entangled state
        total_entanglement * 0.5 + 0.5
    );

    vec3 bell_color = mix(
        vec3(0.3, 0.6, 0.2),  // Bell state 0
        vec3(0.7, 0.8, 0.3),  // Bell state 1
        bell_state * 0.5 + 0.5
    );

    vec3 teleport_color = mix(
        vec3(0.2, 0.3, 0.5),  // Source state
        vec3(0.7, 0.5, 0.8),  // Teleported state
        teleportation
    );

    // Combine visualization components
    color = entanglement_color * (1.0 + total_entanglement * 0.3);
    color = mix(color, bell_color, 0.4);
    color = mix(color, teleport_color, 0.3);

    // Add interference patterns
    color += vec3(0.6, 0.7, 0.8) * interference * 0.2;

    // Add quantum flow
    float flow = sin(dot(normalize(quantum_flow), uv) * 6.0 - quantum_time * 2.0);
    flow = flow * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow * 0.15;

    // Add decoherence visualization
    color = mix(
        color,
        vec3(0.5),  // Mixed state
        decoherence
    );

    // Add quantum measurement effects
    vec2 measure_uv = uv * 12.0;
    float measurement = quantum_noise(measure_uv + quantum_time, 1.0);
    measurement *= step(0.7, measurement); // Collapse threshold
    color += vec3(0.9, 0.8, 0.7) * measurement * 0.2;

    // Add spin correlations
    float spin = atan(uv.y, uv.x) + quantum_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(spin * 4.0) * 0.5 + 0.5) * 0.1;

    // Add quantum uncertainty
    float uncertainty = length(uv);
    uncertainty = sin(uncertainty * 8.0 - quantum_time * 1.5);
    color += vec3(0.7, 0.6, 0.5) * uncertainty * 0.1;

    // Add Planck scale fluctuations
    vec2 planck_uv = uv * 32.0;
    float planck = quantum_noise(planck_uv + quantum_time, 1.0);
    color += vec3(0.4, 0.5, 0.6) * planck * PLANCK_CONSTANT;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
