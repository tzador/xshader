/*
Crystal Growth Simulation
Visualizes crystal nucleation, growth patterns,
lattice formation, and phase transitions.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Crystal parameters
    float crystal_time = t * 0.8;
    float growth_rate = 0.7;
    float nucleation_rate = 0.6;

    // System constants
    const int NUCLEATION_SITES = 8;
    const float LATTICE_SPACING = 0.4;
    const float ANISOTROPY = 0.8;

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
    float crystal_density = 0.0;
    vec2 growth_field = vec2(0.0);

    for(int i = 0; i < NUCLEATION_SITES; i++) {
        float phase = float(i) * 6.28319 / float(NUCLEATION_SITES);
        vec2 nucleus_pos = vec2(
            cos(phase + crystal_time * 0.2),
            sin(phase + crystal_time * 0.3)
        ) * 1.5;

        // Calculate crystal growth from nucleus
        vec2 rel_pos = uv - nucleus_pos;
        float dist = length(rel_pos);

        // Anisotropic growth
        float angle = atan(rel_pos.y, rel_pos.x);
        float symmetry = cos(angle * 6.0) * ANISOTROPY;

        float growth = exp(-dist * (2.0 - symmetry));
        growth *= sin(dist * 8.0 + crystal_time * (1.0 + float(i) * 0.1));

        crystal_density += growth;
        growth_field += normalize(rel_pos) * growth;
    }

    // Generate lattice structure
    float lattice = 0.0;
    vec2 lattice_pos = uv * (1.0 / LATTICE_SPACING);
    vec2 cell = floor(lattice_pos);
    vec2 cell_uv = fract(lattice_pos) - 0.5;

    for(int i = -1; i <= 1; i++) {
        for(int j = -1; j <= 1; j++) {
            vec2 cell_offset = vec2(float(i), float(j));
            vec2 point = cell + cell_offset;

            float cell_phase = crystal_noise(point, 1.0);
            float cell_time = crystal_time * (0.5 + cell_phase * 0.5);

            vec2 point_pos = cell_uv - cell_offset;
            float point_dist = length(point_pos);

            lattice += exp(-point_dist * 8.0) * sin(cell_time * 2.0);
        }
    }

    // Calculate grain boundaries
    float grain_boundary = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 grain_pos = uv * scale + growth_field * crystal_time;

        float boundary = crystal_noise(grain_pos, 2.0);
        boundary = pow(boundary, 1.5);

        grain_boundary += boundary / scale;
    }

    // Generate defect structures
    float defects = 0.0;
    vec2 defect_center = vec2(
        cos(crystal_time * 0.4),
        sin(crystal_time * 0.5)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 defect_dir = vec2(cos(angle), sin(angle));

        float defect = exp(-abs(dot(uv - defect_center, defect_dir)) * 4.0);
        defect *= sin(dot(uv - defect_center, defect_dir) * 12.0 - crystal_time * 3.0);

        defects += defect;
    }

    // Calculate phase transitions
    float phase_field = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 phase_pos = uv * scale + vec2(crystal_time * 0.1);

        float phase = crystal_noise(phase_pos, 4.0);
        phase_field += phase / scale;
    }

    // Create color gradients
    vec3 crystal_color = mix(
        vec3(0.2, 0.4, 0.8),  // Base crystal
        vec3(0.8, 0.3, 0.2),  // Growth front
        crystal_density * 0.5 + 0.5
    );

    vec3 lattice_color = mix(
        vec3(0.3, 0.6, 0.2),  // Lattice valleys
        vec3(0.7, 0.8, 0.3),  // Lattice peaks
        lattice * 0.5 + 0.5
    );

    vec3 boundary_color = mix(
        vec3(0.2, 0.3, 0.5),  // Grain interior
        vec3(0.7, 0.5, 0.8),  // Grain boundary
        grain_boundary
    );

    // Combine visualization components
    color = crystal_color * (1.0 + crystal_density * 0.3);
    color = mix(color, lattice_color, 0.4);
    color = mix(color, boundary_color, 0.3);

    // Add defect visualization
    color += vec3(0.8, 0.7, 0.5) * defects * 0.3;

    // Add phase transition effects
    vec3 phase_color = mix(
        vec3(0.4, 0.6, 0.8),  // Phase A
        vec3(0.8, 0.7, 0.3),  // Phase B
        phase_field
    );
    color = mix(color, phase_color, 0.2);

    // Add growth field flow
    float flow = sin(dot(normalize(growth_field), uv) * 6.0 - crystal_time * 2.0);
    flow = flow * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow * 0.15;

    // Add nucleation sites
    vec2 nuclei_uv = uv * 12.0;
    float nuclei = crystal_noise(nuclei_uv + crystal_time, 1.0);
    nuclei *= step(1.0 - nucleation_rate, nuclei);
    color += vec3(0.9, 0.8, 0.7) * nuclei * 0.2;

    // Add symmetry patterns
    float symmetry = atan(uv.y, uv.x);
    float pattern = sin(symmetry * 6.0 + crystal_time);
    color += vec3(0.6, 0.7, 0.8) * pattern * 0.1;

    // Add strain fields
    float strain = length(uv);
    strain = sin(strain * 8.0 - crystal_time * 1.5);
    color += vec3(0.7, 0.6, 0.5) * strain * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
