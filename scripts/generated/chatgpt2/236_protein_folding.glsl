/*
Protein Folding Simulation
Visualizes protein folding dynamics, molecular interactions,
and conformational changes in a complex biological system.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Simulation parameters
    float mol_time = t * 1.5;
    float energy_level = 0.8;
    float interaction_strength = 0.9;

    // Noise function for molecular motion
    float mol_noise(vec2 p, float freq) {
        vec2 i = floor(p * freq);
        vec2 f = fract(p * freq);

        float a = fract(sin(dot(i, vec2(127.1, 311.7))) * 43758.5453);
        float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
        float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
        float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        f = f * f * (3.0 - 2.0 * f + sin(mol_time + dot(i, f)) * 0.1);

        return mix(
            mix(a, b, f.x),
            mix(c, d, f.x),
            f.y
        );
    }

    // Generate protein backbone
    float backbone = 0.0;
    vec2 fold_center = vec2(
        cos(mol_time * 0.5),
        sin(mol_time * 0.7)
    );

    for(int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398;
        vec2 offset = vec2(
            cos(angle + mol_time),
            sin(angle + mol_time * 0.8)
        );

        vec2 pos = uv - fold_center - offset * 0.5;
        float segment = exp(-length(pos) * 4.0);
        segment *= sin(length(pos) * 16.0 - mol_time * 2.0);

        backbone += segment;
    }

    // Add side chains
    float side_chains = 0.0;
    for(int i = 0; i < 12; i++) {
        float t_offset = mol_time + float(i) * 0.5236;
        vec2 chain_pos = vec2(
            cos(t_offset),
            sin(t_offset * 1.2)
        );

        float chain = exp(-length(uv - chain_pos - fold_center) * 6.0);
        chain *= sin(length(uv - chain_pos) * 24.0 - mol_time * 4.0);

        side_chains += chain;
    }

    // Molecular interactions
    float interactions = 0.0;
    for(int i = 0; i < 6; i++) {
        float angle = float(i) * 1.0472;
        vec2 pos = vec2(
            cos(angle + mol_time * 0.7),
            sin(angle + mol_time * 0.5)
        );

        float interaction = exp(-length(uv - pos) * 3.0);
        interaction *= sin(length(uv - pos) * 12.0 - mol_time * 3.0);

        interactions += interaction;
    }

    // Water molecules and hydrogen bonds
    float water = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 water_uv = uv * scale + vec2(
            cos(mol_time * 0.3 * scale),
            sin(mol_time * 0.4 * scale)
        );
        water += mol_noise(water_uv, 1.0) / scale;
    }

    // Energy landscape
    float energy = 0.0;
    vec2 energy_center = fold_center * 0.5;
    float energy_radius = 1.0 + sin(mol_time) * 0.3;
    energy = exp(-pow(length(uv - energy_center) - energy_radius, 2.0) * 2.0);
    energy *= sin(length(uv - energy_center) * 8.0 - mol_time * 2.0);

    // Combine molecular components
    float protein = backbone * 0.5 + 0.5;
    float chains = side_chains * 0.5 + 0.5;
    float molecular_interactions = interactions * 0.5 + 0.5;
    float water_interactions = water * 0.5 + 0.5;

    // Create color gradients for different molecular components
    vec3 protein_color = mix(
        vec3(0.2, 0.5, 0.7),  // Hydrophilic regions
        vec3(0.7, 0.5, 0.2),  // Hydrophobic regions
        protein
    );

    vec3 chain_color = mix(
        vec3(0.3, 0.6, 0.2),  // Polar side chains
        vec3(0.8, 0.4, 0.1),  // Non-polar side chains
        chains
    );

    vec3 interaction_color = mix(
        vec3(0.2, 0.3, 0.5),  // Weak interactions
        vec3(0.6, 0.8, 0.9),  // Strong interactions
        molecular_interactions
    );

    // Combine colors with interaction weights
    color = protein_color * (1.0 + protein * 0.5);
    color += chain_color * chains * interaction_strength;
    color += interaction_color * interactions * interaction_strength;

    // Add water effects
    color = mix(
        color,
        vec3(0.4, 0.6, 0.8),
        water_interactions * 0.2
    );

    // Add energy landscape visualization
    color += vec3(0.8, 0.7, 0.5) * energy * energy_level;

    // Add hydrogen bonds
    vec2 h_bond_uv = uv * 16.0;
    float h_bonds = mol_noise(h_bond_uv + mol_time, 1.0);
    color += vec3(0.6, 0.8, 1.0) * h_bonds * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.15);

    return vec4(color, 1.0);
}
