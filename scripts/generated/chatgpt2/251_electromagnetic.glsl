/*
Electromagnetic Field Dynamics
Visualizes electromagnetic wave propagation, field interactions,
charge distributions, and electromagnetic induction.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Field parameters
    float em_time = t * 2.0;
    float field_strength = 0.9;
    float charge_density = 0.8;

    // System parameters
    const int CHARGE_POINTS = 6;
    const float WAVE_SPEED = 2.0;

    // Field noise function
    float field_noise(vec2 p, float freq) {
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

    // Generate charge distributions
    float electric_field = 0.0;
    float magnetic_field = 0.0;
    vec2 field_flow = vec2(0.0);

    for(int i = 0; i < CHARGE_POINTS; i++) {
        float phase = float(i) * 6.28319 / float(CHARGE_POINTS);
        vec2 charge_pos = vec2(
            cos(phase + em_time * 0.3),
            sin(phase + em_time * 0.4)
        ) * 1.5;

        // Calculate electric field
        vec2 rel_pos = uv - charge_pos;
        float dist = length(rel_pos);
        vec2 field_dir = normalize(rel_pos);

        // Coulomb's law
        float charge = sin(phase + em_time);
        float e_field = charge / (dist * dist + 0.1);
        electric_field += e_field;

        // Calculate magnetic field (perpendicular to electric field)
        vec2 current_dir = vec2(
            cos(em_time * (0.7 + float(i))),
            sin(em_time * (0.8 + float(i)))
        );
        float m_field = charge * dot(current_dir, field_dir) / (dist + 0.1);
        magnetic_field += m_field;

        field_flow += field_dir * e_field;
    }

    // Generate electromagnetic waves
    float em_waves = 0.0;
    vec2 wave_center = vec2(
        cos(em_time * 0.5),
        sin(em_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 wave_dir = vec2(cos(angle), sin(angle));

        // Wave equation
        float wave = sin(dot(uv - wave_center, wave_dir) * 8.0 - em_time * WAVE_SPEED);
        em_waves += wave;
    }

    // Calculate electromagnetic induction
    float induction = 0.0;
    vec2 induction_center = vec2(
        cos(em_time * 0.4),
        sin(em_time * 0.6)
    );

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 loop_dir = vec2(cos(angle), sin(angle));

        float flux = dot(field_flow, loop_dir);
        float induced_emf = cos(flux * 8.0 - em_time * 4.0);

        induction += induced_emf;
    }

    // Generate field fluctuations
    float fluctuations = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 fluct_pos = uv * scale + field_flow * em_time;

        fluctuations += field_noise(fluct_pos, 1.0) / scale;
    }

    // Create interference patterns
    float interference = 0.0;
    for(int i = 0; i < CHARGE_POINTS; i++) {
        float phase = float(i) * 6.28319 / float(CHARGE_POINTS);
        vec2 source_pos = vec2(
            cos(phase + em_time * 0.2),
            sin(phase + em_time * 0.3)
        ) * 1.5;

        float wave = sin(length(uv - source_pos) * 8.0 - em_time * WAVE_SPEED);
        interference += wave;
    }

    // Create color gradients
    vec3 electric_color = mix(
        vec3(0.2, 0.4, 0.8),  // Negative charge
        vec3(0.8, 0.3, 0.2),  // Positive charge
        electric_field * 0.5 + 0.5
    );

    vec3 magnetic_color = mix(
        vec3(0.3, 0.7, 0.2),  // Weak field
        vec3(0.9, 0.8, 0.3),  // Strong field
        abs(magnetic_field)
    );

    vec3 wave_color = mix(
        vec3(0.2, 0.3, 0.5),  // Wave troughs
        vec3(0.7, 0.5, 0.8),  // Wave peaks
        em_waves * 0.5 + 0.5
    );

    // Combine visualization components
    color = electric_color * (1.0 + abs(electric_field) * 0.5);
    color += magnetic_color * abs(magnetic_field) * field_strength;
    color += wave_color * em_waves * 0.3;

    // Add induction effects
    vec3 induction_color = mix(
        vec3(0.4, 0.6, 0.8),  // Low induction
        vec3(0.8, 0.7, 0.3),  // High induction
        abs(induction)
    );
    color += induction_color * abs(induction) * 0.3;

    // Add interference patterns
    color += vec3(0.6, 0.7, 0.8) * interference * 0.2;

    // Add field fluctuations
    color += vec3(0.5, 0.6, 0.7) * fluctuations * 0.2;

    // Add field lines
    float field_lines = sin(dot(normalize(field_flow), uv) * 8.0 - em_time * 2.0);
    field_lines = field_lines * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * field_lines * 0.1;

    // Add charge density visualization
    float density = 0.0;
    for(int i = 0; i < CHARGE_POINTS; i++) {
        float phase = float(i) * 6.28319 / float(CHARGE_POINTS);
        vec2 charge_pos = vec2(cos(phase), sin(phase)) * 1.5;

        density += exp(-length(uv - charge_pos) * 4.0);
    }
    color = mix(color, vec3(0.9, 0.8, 0.7), density * charge_density * 0.3);

    // Add quantum electromagnetic effects
    vec2 quantum_uv = uv * 16.0;
    float quantum = field_noise(quantum_uv + em_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
