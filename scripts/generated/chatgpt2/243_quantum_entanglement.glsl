/*
Quantum Entanglement Network
Visualizes quantum entangled particle systems, Bell states,
and quantum teleportation effects with decoherence.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Quantum parameters
    float quantum_time = t * 1.5;
    float coherence = 0.8;
    float entanglement_strength = 0.9;

    // Bell state parameters
    const int PARTICLE_PAIRS = 6;
    const float TELEPORT_RATE = 0.3;

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
    float entanglement = 0.0;
    float teleportation = 0.0;

    for(int i = 0; i < PARTICLE_PAIRS; i++) {
        float angle = float(i) * 6.28319 / float(PARTICLE_PAIRS);

        // Particle positions
        vec2 center = vec2(
            cos(angle + quantum_time * 0.2),
            sin(angle + quantum_time * 0.3)
        ) * 1.5;

        vec2 particle1 = center + vec2(
            cos(quantum_time + angle),
            sin(quantum_time + angle)
        ) * 0.3;

        vec2 particle2 = center - vec2(
            cos(quantum_time + angle),
            sin(quantum_time + angle)
        ) * 0.3;

        // Quantum state evolution
        float state1 = quantum_noise(particle1 + quantum_time * vec2(0.1), 4.0);
        float state2 = 1.0 - state1; // Entangled anti-correlated state

        // Calculate entanglement strength
        float ent_strength = exp(-length(particle1 - particle2) * 2.0);
        ent_strength *= coherence;

        // Add particle visualization
        float p1 = exp(-length(uv - particle1) * 8.0);
        float p2 = exp(-length(uv - particle2) * 8.0);

        // Add quantum tunneling
        float tunnel = exp(-length(particle1 - particle2) * 4.0);

        // Add to total entanglement
        entanglement += (p1 * state1 + p2 * state2) * ent_strength;

        // Calculate teleportation effects
        float teleport = 0.0;
        for(int j = 0; j < PARTICLE_PAIRS; j++) {
            if(i != j) {
                float other_angle = float(j) * 6.28319 / float(PARTICLE_PAIRS);
                vec2 other_center = vec2(
                    cos(other_angle + quantum_time * 0.2),
                    sin(other_angle + quantum_time * 0.3)
                ) * 1.5;

                float transfer = exp(-length(center - other_center) * 4.0);
                transfer *= sin(quantum_time * TELEPORT_RATE + float(i + j));

                teleport += transfer * tunnel;
            }
        }

        teleportation += teleport;
    }

    // Generate quantum field fluctuations
    float quantum_field = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 qf_pos = uv * scale + vec2(
            cos(quantum_time * 0.3 * scale),
            sin(quantum_time * 0.4 * scale)
        );

        quantum_field += quantum_noise(qf_pos, 1.0) / scale;
    }

    // Create decoherence patterns
    float decoherence = 0.0;
    vec2 decohere_center = vec2(
        cos(quantum_time * 0.5),
        sin(quantum_time * 0.7)
    );

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 offset = vec2(cos(angle), sin(angle));

        float pattern = exp(-length(uv - decohere_center - offset) * 4.0);
        pattern *= sin(length(uv - decohere_center) * 8.0 - quantum_time * 2.0);

        decoherence += pattern;
    }

    // Create color gradients
    vec3 entanglement_color = mix(
        vec3(0.2, 0.4, 0.8),  // Unentangled state
        vec3(0.8, 0.3, 0.2),  // Entangled state
        entanglement
    );

    vec3 teleport_color = mix(
        vec3(0.3, 0.7, 0.2),  // No teleportation
        vec3(0.9, 0.8, 0.3),  // Active teleportation
        teleportation
    );

    vec3 quantum_color = mix(
        vec3(0.2, 0.3, 0.5),  // Ground state
        vec3(0.7, 0.5, 0.8),  // Excited state
        quantum_field
    );

    // Combine visualization components
    color = entanglement_color * (1.0 + entanglement * 0.5);
    color += teleport_color * teleportation * entanglement_strength;
    color += quantum_color * quantum_field * 0.3;

    // Add decoherence effects
    color = mix(
        color,
        vec3(0.2, 0.3, 0.4),
        decoherence * (1.0 - coherence)
    );

    // Add quantum interference patterns
    vec2 interference_uv = uv * 8.0;
    float interference = sin(interference_uv.x + quantum_time) *
        sin(interference_uv.y + quantum_time * 1.2);
    color += vec3(0.5, 0.6, 0.7) * interference * 0.1;

    // Add measurement effects
    float measurement = step(0.98, fract(quantum_time));
    color = mix(color, vec3(1.0), measurement * entanglement);

    // Add quantum uncertainty visualization
    vec2 uncertainty_uv = uv * 16.0;
    float uncertainty = quantum_noise(uncertainty_uv + quantum_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * uncertainty * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
