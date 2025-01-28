/*
Quantum Wave Function
Visualizes probability densities, wave packet evolution,
quantum tunneling, and interference patterns.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Quantum parameters
    float wave_time = t * 1.5;
    float potential = 0.8;
    float tunneling = 0.7;

    // System parameters
    const int WAVE_PACKETS = 5;
    const float PLANCK_CONSTANT = 0.1;

    // Wave noise function
    float wave_noise(vec2 p, float freq) {
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

    // Generate wave packets
    float psi_real = 0.0;
    float psi_imag = 0.0;

    for(int i = 0; i < WAVE_PACKETS; i++) {
        float phase = float(i) * 6.28319 / float(WAVE_PACKETS);
        vec2 packet_pos = vec2(
            cos(phase + wave_time * 0.3),
            sin(phase + wave_time * 0.4)
        ) * 1.5;

        // Wave packet parameters
        float k = float(i + 1) * 3.14159;
        float omega = k * k * PLANCK_CONSTANT / 2.0;
        float width = 0.5 / sqrt(float(i + 1));

        // Calculate wave function components
        vec2 rel_pos = uv - packet_pos;
        float dist = length(rel_pos);
        float gaussian = exp(-dist * dist / (width * width));

        float phase_factor = k * dist - omega * wave_time;
        psi_real += gaussian * cos(phase_factor);
        psi_imag += gaussian * sin(phase_factor);
    }

    // Calculate probability density
    float probability = psi_real * psi_real + psi_imag * psi_imag;

    // Generate potential barrier
    float barrier = 0.0;
    vec2 barrier_center = vec2(
        cos(wave_time * 0.5),
        sin(wave_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 barrier_dir = vec2(cos(angle), sin(angle));

        float wall = exp(-abs(dot(uv - barrier_center, barrier_dir)) * 8.0);
        barrier += wall;
    }

    // Calculate tunneling effect
    float tunnel_effect = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 tunnel_pos = uv * scale + vec2(
            cos(wave_time * 0.2 * scale),
            sin(wave_time * 0.3 * scale)
        );

        float tunnel = wave_noise(tunnel_pos, 2.0);
        tunnel_effect += tunnel / scale;
    }

    // Generate interference patterns
    float interference = 0.0;
    for(int i = 0; i < WAVE_PACKETS; i++) {
        for(int j = i + 1; j < WAVE_PACKETS; j++) {
            float phase_i = float(i) * 6.28319 / float(WAVE_PACKETS);
            float phase_j = float(j) * 6.28319 / float(WAVE_PACKETS);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            float pattern = sin(length(uv - pos_i) * 8.0 - wave_time) *
                           sin(length(uv - pos_j) * 8.0 - wave_time);
            interference += pattern;
        }
    }

    // Calculate quantum phase
    float phase = atan(psi_imag, psi_real);

    // Generate uncertainty principle effects
    float uncertainty = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 uncert_pos = uv * scale;

        float delta_x = wave_noise(uncert_pos + wave_time, 4.0);
        float delta_p = wave_noise(uncert_pos - wave_time, 4.0);

        uncertainty += delta_x * delta_p * PLANCK_CONSTANT;
    }

    // Create color gradients
    vec3 probability_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low probability
        vec3(0.8, 0.3, 0.2),  // High probability
        probability
    );

    vec3 phase_color = mix(
        vec3(0.3, 0.7, 0.2),  // Phase 0
        vec3(0.9, 0.8, 0.3),  // Phase 2π
        phase * 0.159 + 0.5
    );

    vec3 tunnel_color = mix(
        vec3(0.2, 0.3, 0.5),  // Classical region
        vec3(0.7, 0.5, 0.8),  // Tunneling region
        tunnel_effect
    );

    // Combine visualization components
    color = probability_color * (1.0 + probability * 0.5);
    color = mix(color, phase_color, 0.3);
    color += tunnel_color * tunnel_effect * tunneling;

    // Add barrier effects
    color = mix(
        color,
        vec3(0.4, 0.6, 0.8),
        barrier * potential
    );

    // Add interference visualization
    color += vec3(0.6, 0.7, 0.8) * interference * 0.2;

    // Add uncertainty principle effects
    color = mix(
        color,
        vec3(0.8, 0.7, 0.6),
        uncertainty * 0.2
    );

    // Add wave packet envelope
    float envelope = 0.0;
    for(int i = 0; i < WAVE_PACKETS; i++) {
        float phase = float(i) * 6.28319 / float(WAVE_PACKETS);
        vec2 packet_pos = vec2(cos(phase), sin(phase)) * 1.5;

        envelope += exp(-length(uv - packet_pos) * 4.0);
    }
    color += vec3(0.7, 0.8, 0.9) * envelope * 0.2;

    // Add quantum beats
    vec2 beat_uv = uv * 8.0;
    float beats = sin(beat_uv.x + wave_time) * sin(beat_uv.y + wave_time * 1.2);
    color += vec3(0.5, 0.6, 0.7) * beats * 0.1;

    // Add quantum noise
    vec2 quantum_uv = uv * 32.0;
    float quantum_noise = wave_noise(quantum_uv + wave_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum_noise * PLANCK_CONSTANT;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
