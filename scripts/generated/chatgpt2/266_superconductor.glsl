/*
Superconductor Dynamics
Visualizes Cooper pairs, magnetic flux vortices,
and Josephson junction effects.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Superconductor parameters
    float super_time = t * 0.7;
    float cooper_density = 0.8;
    float magnetic_field = 0.6;

    // Physical constants
    const float CRITICAL_TEMPERATURE = 0.2;
    const float LONDON_PENETRATION = 0.3;
    const int VORTEX_COUNT = 6;

    // Superconductor noise function
    float super_noise(vec2 p, float freq) {
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

    // Generate Cooper pair condensate
    float condensate = 0.0;
    vec2 supercurrent = vec2(0.0);

    for(int i = 0; i < VORTEX_COUNT; i++) {
        float phase = float(i) * 6.28319 / float(VORTEX_COUNT);
        vec2 vortex_pos = vec2(
            cos(phase + super_time * 0.3),
            sin(phase + super_time * 0.4)
        ) * 1.5;

        // Calculate Cooper pair flow
        vec2 rel_pos = uv - vortex_pos;
        float dist = length(rel_pos);

        float pair_density = exp(-dist * 2.0) * cooper_density;
        pair_density *= sin(dist * 8.0 + super_time * (1.0 + float(i) * 0.1));

        condensate += pair_density;
        supercurrent += normalize(rel_pos) * pair_density;
    }

    // Calculate magnetic flux vortices
    float vortex_field = 0.0;
    vec2 magnetic_flow = vec2(0.0);

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 field_dir = vec2(cos(angle), sin(angle));

        float field = exp(-abs(dot(uv, field_dir)) * 3.0);
        field *= sin(dot(uv, field_dir) * 8.0 - super_time * 2.0);

        vortex_field += field;
        magnetic_flow += field_dir * field;
    }

    // Generate Josephson junctions
    float josephson = 0.0;
    vec2 junction_center = vec2(
        cos(super_time * 0.5),
        sin(super_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 junction_pos = uv * scale + supercurrent * super_time;

        float tunnel = super_noise(junction_pos, 4.0);
        josephson += tunnel / scale;
    }

    // Calculate phase coherence
    float coherence = 0.0;
    for(int i = 0; i < VORTEX_COUNT; i++) {
        for(int j = i + 1; j < VORTEX_COUNT; j++) {
            float phase_i = float(i) * 6.28319 / float(VORTEX_COUNT);
            float phase_j = float(j) * 6.28319 / float(VORTEX_COUNT);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            float correlation = sin(length(uv - pos_i) * 8.0 - super_time) *
                               sin(length(uv - pos_j) * 8.0 - super_time);
            coherence += correlation;
        }
    }

    // Generate Meissner effect
    float meissner = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 meissner_pos = uv * scale + magnetic_flow * super_time;

        float expulsion = super_noise(meissner_pos, 2.0);
        expulsion *= exp(-length(uv) / LONDON_PENETRATION);

        meissner += expulsion / scale;
    }

    // Calculate temperature effects
    float temperature = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 temp_pos = uv * scale + vec2(super_time * 0.2);

        float thermal = super_noise(temp_pos, 2.0);
        temperature += thermal / scale;
    }
    temperature *= CRITICAL_TEMPERATURE;

    // Create color gradients
    vec3 condensate_color = mix(
        vec3(0.2, 0.4, 0.8),  // Normal state
        vec3(0.8, 0.3, 0.2),  // Superconducting state
        condensate * 0.5 + 0.5
    );

    vec3 vortex_color = mix(
        vec3(0.3, 0.6, 0.2),  // Low field
        vec3(0.7, 0.8, 0.3),  // High field
        vortex_field * 0.5 + 0.5
    );

    vec3 junction_color = mix(
        vec3(0.2, 0.3, 0.5),  // No tunneling
        vec3(0.7, 0.5, 0.8),  // Active tunneling
        josephson
    );

    // Combine visualization components
    color = condensate_color * (1.0 + condensate * 0.3);
    color = mix(color, vortex_color, 0.4);
    color = mix(color, junction_color, 0.3);

    // Add coherence effects
    color += vec3(0.6, 0.7, 0.8) * coherence * 0.2;

    // Add supercurrent flow
    float flow = sin(dot(normalize(supercurrent), uv) * 6.0 - super_time * 2.0);
    flow = flow * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow * 0.15;

    // Add Meissner effect
    color = mix(
        color,
        vec3(0.4, 0.6, 0.8),
        meissner * magnetic_field
    );

    // Add temperature visualization
    color = mix(
        color,
        vec3(0.8, 0.4, 0.3),
        smoothstep(0.8 * CRITICAL_TEMPERATURE, CRITICAL_TEMPERATURE, temperature)
    );

    // Add quantum phase effects
    float phase = atan(uv.y, uv.x) + super_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(phase * 4.0) * 0.5 + 0.5) * 0.1;

    // Add flux quantization
    float flux = length(uv);
    flux = sin(flux * 8.0 - super_time * 1.5);
    color += vec3(0.7, 0.6, 0.5) * flux * 0.1;

    // Add microscopic fluctuations
    vec2 micro_uv = uv * 32.0;
    float micro = super_noise(micro_uv + super_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * micro * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
