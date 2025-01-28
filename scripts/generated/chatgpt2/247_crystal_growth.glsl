/*
Crystal Growth Simulation
Visualizes crystal nucleation, growth patterns, defect
formation, and phase transitions in crystalline materials.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Crystal parameters
    float growth_time = t * 1.5;
    float nucleation_rate = 0.8;
    float growth_rate = 0.9;

    // Lattice parameters
    const int NUCLEATION_SITES = 6;
    const float ANISOTROPY = 0.7;

    // Crystal noise function
    float crystal_noise(vec2 p, float freq) {
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

    // Generate nucleation sites
    float crystallization = 0.0;
    float orientation = 0.0;

    for(int i = 0; i < NUCLEATION_SITES; i++) {
        float phase = float(i) * 6.28319 / float(NUCLEATION_SITES);
        vec2 nucleus_pos = vec2(
            cos(phase + growth_time * 0.2),
            sin(phase + growth_time * 0.3)
        ) * 1.5;

        // Calculate crystal growth from nucleus
        vec2 rel_pos = uv - nucleus_pos;
        float dist = length(rel_pos);
        float angle = atan(rel_pos.y, rel_pos.x);

        // Anisotropic growth
        float crystal_angle = floor(angle * 6.0 / 6.28319) * 6.28319 / 6.0;
        float anisotropic_dist = mix(dist, abs(cos(angle - crystal_angle)) * dist, ANISOTROPY);

        // Growth front
        float growth_front = smoothstep(
            growth_time * growth_rate,
            growth_time * growth_rate - 0.5,
            anisotropic_dist
        );

        // Add orientation field
        float local_orientation = crystal_angle + phase;
        orientation += local_orientation * growth_front;

        crystallization += growth_front;
    }

    // Generate crystal lattice
    float lattice = 0.0;
    vec2 lattice_uv = uv * 8.0;

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 lattice_dir = vec2(cos(angle), sin(angle));

        float pattern = cos(dot(lattice_uv, lattice_dir) * 2.0);
        lattice += pattern;
    }

    // Create defect patterns
    float defects = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 defect_pos = uv * scale + vec2(
            cos(growth_time * 0.3 * scale),
            sin(growth_time * 0.4 * scale)
        );

        defects += crystal_noise(defect_pos, 1.0) / scale;
    }

    // Simulate grain boundaries
    float grain_boundaries = 0.0;
    for(int i = 0; i < NUCLEATION_SITES; i++) {
        for(int j = i + 1; j < NUCLEATION_SITES; j++) {
            float phase_i = float(i) * 6.28319 / float(NUCLEATION_SITES);
            float phase_j = float(j) * 6.28319 / float(NUCLEATION_SITES);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            vec2 boundary_dir = normalize(pos_j - pos_i);
            float boundary = exp(-abs(dot(uv - pos_i, vec2(boundary_dir.y, -boundary_dir.x))) * 8.0);

            grain_boundaries += boundary;
        }
    }

    // Calculate phase transitions
    float phase_transition = 0.0;
    vec2 transition_center = vec2(
        cos(growth_time * 0.5),
        sin(growth_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        float transition = exp(-length(uv - transition_center - offset) * 2.0);
        transition *= sin(length(uv - transition_center) * 8.0 - growth_time * 2.0);

        phase_transition += transition;
    }

    // Create color gradients
    vec3 crystal_color = mix(
        vec3(0.2, 0.4, 0.8),  // Amorphous phase
        vec3(0.8, 0.7, 0.2),  // Crystalline phase
        crystallization
    );

    vec3 lattice_color = mix(
        vec3(0.3, 0.5, 0.7),  // Lattice valleys
        vec3(0.7, 0.8, 0.9),  // Lattice peaks
        lattice * 0.5 + 0.5
    );

    vec3 defect_color = mix(
        vec3(0.8, 0.3, 0.2),  // Defect core
        vec3(0.2, 0.5, 0.8),  // Perfect crystal
        smoothstep(0.4, 0.6, defects)
    );

    // Combine visualization components
    color = crystal_color * (1.0 + crystallization * 0.5);
    color *= lattice_color * (0.8 + 0.4 * smoothstep(0.0, 1.0, crystallization));
    color = mix(color, defect_color, defects * 0.3);

    // Add grain boundary effects
    color = mix(
        color,
        vec3(0.2, 0.3, 0.4),
        grain_boundaries * 0.5
    );

    // Add phase transition effects
    color += vec3(0.8, 0.9, 1.0) * phase_transition * 0.2;

    // Add orientation visualization
    float orientation_pattern = sin(orientation * 4.0);
    color += vec3(0.5, 0.6, 0.7) * orientation_pattern * 0.1;

    // Add nucleation sites
    float nuclei = 0.0;
    for(int i = 0; i < NUCLEATION_SITES; i++) {
        float phase = float(i) * 6.28319 / float(NUCLEATION_SITES);
        vec2 nucleus_pos = vec2(cos(phase), sin(phase)) * 1.5;

        nuclei += exp(-length(uv - nucleus_pos) * 8.0);
    }
    color += vec3(1.0) * nuclei * nucleation_rate;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
