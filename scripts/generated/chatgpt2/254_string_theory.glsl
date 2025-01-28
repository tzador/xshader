/*
String Theory Dimensions
Visualizes vibrating strings, compactified dimensions,
brane dynamics, and higher-dimensional phenomena.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // String parameters
    float string_time = t * 2.0;
    float tension = 0.9;
    float coupling = 0.8;

    // System parameters
    const int STRING_MODES = 6;
    const float COMPACTIFICATION_RADIUS = 0.2;

    // String noise function
    float string_noise(vec2 p, float freq) {
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

    // Generate vibrating strings
    float string_amplitude = 0.0;
    vec2 string_flow = vec2(0.0);

    for(int i = 0; i < STRING_MODES; i++) {
        float phase = float(i) * 6.28319 / float(STRING_MODES);

        // String worldsheet
        vec2 string_pos = vec2(
            cos(phase + string_time * 0.3),
            sin(phase + string_time * 0.4)
        ) * 1.5;

        // String oscillations
        float mode = float(i + 1);
        float frequency = mode * 3.14159;
        float amplitude = 1.0 / sqrt(mode);

        // Calculate string vibration
        vec2 rel_pos = uv - string_pos;
        float dist = length(rel_pos);

        float vibration = amplitude * sin(frequency * dist - string_time * mode);
        vibration *= exp(-dist * 2.0);

        string_amplitude += vibration;
        string_flow += normalize(rel_pos) * vibration;
    }

    // Generate compactified dimensions
    float compact_dims = 0.0;
    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 dim_dir = vec2(cos(angle), sin(angle));

        // Kaluza-Klein modes
        float radius = COMPACTIFICATION_RADIUS * (1.0 + 0.2 * sin(string_time + float(i)));
        float winding = sin(dot(uv, dim_dir) / radius + string_time * (float(i) + 1.0));

        compact_dims += winding;
    }

    // Calculate brane dynamics
    float brane_field = 0.0;
    vec2 brane_center = vec2(
        cos(string_time * 0.5),
        sin(string_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 brane_dir = vec2(cos(angle), sin(angle));

        // D-brane fluctuations
        float brane = exp(-length(uv - brane_center - brane_dir) * 4.0);
        brane *= sin(dot(uv - brane_center, brane_dir) * 8.0 - string_time * 2.0);

        brane_field += brane;
    }

    // Generate string interactions
    float interactions = 0.0;
    for(int i = 0; i < STRING_MODES; i++) {
        for(int j = i + 1; j < STRING_MODES; j++) {
            float phase_i = float(i) * 6.28319 / float(STRING_MODES);
            float phase_j = float(j) * 6.28319 / float(STRING_MODES);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            // String joining/splitting
            float interaction = exp(-length(uv - pos_i) * 2.0) * exp(-length(uv - pos_j) * 2.0);
            interaction *= sin(string_time * (float(i + j) * 0.1));

            interactions += interaction;
        }
    }

    // Calculate moduli space
    float moduli = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 moduli_pos = uv * scale + string_flow * string_time;

        moduli += string_noise(moduli_pos, 1.0) / scale;
    }

    // Generate supersymmetric partners
    float susy = 0.0;
    for(int i = 0; i < STRING_MODES; i++) {
        float phase = float(i) * 6.28319 / float(STRING_MODES);
        vec2 partner_pos = vec2(
            cos(phase + string_time * 0.2),
            sin(phase + string_time * 0.3)
        ) * 1.5;

        float partner = exp(-length(uv - partner_pos) * 4.0);
        partner *= sin(length(uv - partner_pos) * 8.0 + string_time * 2.0);

        susy += partner;
    }

    // Create color gradients
    vec3 string_color = mix(
        vec3(0.2, 0.4, 0.8),  // Ground state
        vec3(0.8, 0.3, 0.2),  // Excited state
        string_amplitude * 0.5 + 0.5
    );

    vec3 compact_color = mix(
        vec3(0.3, 0.7, 0.2),  // Small radius
        vec3(0.9, 0.8, 0.3),  // Large radius
        compact_dims * 0.5 + 0.5
    );

    vec3 brane_color = mix(
        vec3(0.2, 0.3, 0.5),  // Low energy
        vec3(0.7, 0.5, 0.8),  // High energy
        brane_field
    );

    // Combine visualization components
    color = string_color * (1.0 + string_amplitude * 0.5);
    color += compact_color * compact_dims * tension;
    color += brane_color * brane_field * coupling;

    // Add interaction effects
    vec3 interaction_color = mix(
        vec3(0.4, 0.6, 0.8),  // Weak coupling
        vec3(0.8, 0.7, 0.3),  // Strong coupling
        interactions
    );
    color += interaction_color * interactions * 0.3;

    // Add moduli space effects
    color = mix(
        color,
        vec3(0.6, 0.8, 0.9),
        moduli * 0.2
    );

    // Add supersymmetry effects
    color += vec3(0.7, 0.8, 0.9) * susy * 0.2;

    // Add holographic effects
    vec2 holo_uv = uv * 8.0;
    float hologram = sin(holo_uv.x + string_time) * sin(holo_uv.y + string_time * 1.2);
    color += vec3(0.5, 0.6, 0.7) * hologram * 0.1;

    // Add Calabi-Yau manifold suggestion
    float calabi_yau = 0.0;
    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 cy_pos = vec2(cos(angle), sin(angle)) * COMPACTIFICATION_RADIUS;

        calabi_yau += exp(-length(uv - cy_pos) * 8.0);
    }
    color = mix(color, vec3(0.9, 0.8, 0.7), calabi_yau * 0.2);

    // Add quantum corrections
    vec2 quantum_uv = uv * 16.0;
    float quantum = string_noise(quantum_uv + string_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
