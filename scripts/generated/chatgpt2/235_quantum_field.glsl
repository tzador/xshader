/*
Quantum Field Theory
Visualizes quantum field fluctuations, virtual particle
pairs, and field interactions with wave function collapse.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Field parameters
    float field_strength = 1.0;
    float interaction_strength = 0.8;
    float quantum_time = t * 2.0;

    // Quantum noise function for field fluctuations
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

    // Generate quantum field fluctuations
    float field = 0.0;
    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        field += quantum_noise(uv + vec2(cos(quantum_time * 0.7), sin(quantum_time * 0.5)) * 0.1, scale)
                * field_strength / scale;
    }

    // Create virtual particle pairs
    float particles = 0.0;
    for(int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398;
        vec2 offset = vec2(cos(angle + quantum_time), sin(angle + quantum_time * 1.2));

        // Particle position and wave function
        vec2 pos = uv + offset;
        float wave = exp(-length(pos) * 2.0);
        float phase = sin(length(pos) * 8.0 - quantum_time * 4.0);

        particles += wave * phase;
    }

    // Add field interactions
    float interactions = 0.0;
    for(int i = 0; i < 6; i++) {
        float t_offset = quantum_time + float(i) * 1.0472;
        vec2 pos = vec2(
            cos(t_offset),
            sin(t_offset * 0.7)
        );

        float interaction = exp(-length(uv - pos) * 3.0);
        interaction *= sin(length(uv - pos) * 12.0 - quantum_time * 6.0);

        interactions += interaction;
    }

    // Wave function collapse effects
    float collapse = 0.0;
    vec2 collapse_center = vec2(
        cos(quantum_time * 0.5),
        sin(quantum_time * 0.7)
    ) * 2.0;

    float collapse_radius = 1.0 + sin(quantum_time) * 0.5;
    float collapse_wave = exp(-pow(length(uv - collapse_center) - collapse_radius, 2.0) * 4.0);
    collapse = collapse_wave * sin(length(uv - collapse_center) * 16.0 - quantum_time * 8.0);

    // Combine quantum effects
    float quantum_field = field * 0.5 + 0.5;
    float quantum_particles = particles * 0.5 + 0.5;
    float quantum_interactions = interactions * 0.5 + 0.5;

    // Create color gradients for different quantum phenomena
    vec3 field_color = mix(
        vec3(0.1, 0.2, 0.4),  // Low energy state
        vec3(0.4, 0.6, 0.8),  // High energy state
        quantum_field
    );

    vec3 particle_color = mix(
        vec3(0.2, 0.4, 0.1),  // Virtual particles
        vec3(0.8, 0.6, 0.2),  // Real particles
        quantum_particles
    );

    vec3 interaction_color = mix(
        vec3(0.2, 0.1, 0.3),  // Weak interaction
        vec3(0.8, 0.3, 0.5),  // Strong interaction
        quantum_interactions
    );

    // Combine colors with interaction weights
    color = field_color * (1.0 + field * 0.5);
    color += particle_color * particles * interaction_strength;
    color += interaction_color * interactions * interaction_strength;

    // Add collapse effects
    color += vec3(0.8, 0.9, 1.0) * collapse * 0.3;

    // Add quantum foam background
    vec2 foam_uv = uv * 32.0;
    float foam = quantum_noise(foam_uv + quantum_time, 1.0);
    color += vec3(0.2, 0.3, 0.4) * foam * 0.05;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
